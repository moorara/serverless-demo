# https://www.terraform.io/docs/configuration/terraform.html
terraform {
  # Equivalent to ">= 0.12, < 1.0"
  required_version = "~> 0.12"
  backend "s3" {}
}

# https://www.terraform.io/docs/providers/aws
# https://www.terraform.io/docs/configuration/providers.html#version-provider-versions
provider "aws" {
  # Equivalent to ">= 2.34.0, < 2.0.0"
  version    = "~> 2.34"  
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

# https://www.terraform.io/docs/configuration/locals.html
locals {
  env_domain = "${var.environment}.${var.domain}"
  domain     = "${var.environment == "prod" ? var.domain : local.env_domain}"

  client_path  = "${path.module}/../../client"
  project_path = "${path.module}/../.."
}

# https://www.terraform.io/docs/providers/aws/d/s3_bucket.html
data "aws_s3_bucket" "webapp" {
  bucket = local.env_domain
}

# https://www.terraform.io/docs/providers/aws/d/acm_certificate.html
data "aws_acm_certificate" "primary" {
  domain   = local.domain
  statuses = [ "ISSUED" ]
}

##################################################  UPLOAD WEBAPP  ##################################################

# Build client app production bundle
# https://www.terraform.io/docs/provisioners/null_resource.html
# https://www.terraform.io/docs/provisioners/local-exec.html
resource "null_resource" "build_client" {
  provisioner "local-exec" {
    working_dir = local.client_path
    command     = "yarn run build 1> /dev/null"
  }
}

# Upload client app bundle to S3 bucket
# https://www.terraform.io/docs/provisioners/null_resource.html
# https://www.terraform.io/docs/provisioners/local-exec.html
resource "null_resource" "upload_client" {
  depends_on = [ "null_resource.build_client" ]

  provisioner "local-exec" {
    working_dir = "${local.client_path}/build"
    command     = "aws s3 sync . s3://${data.aws_s3_bucket.webapp.id}"

    environment = {
      AWS_ACCESS_KEY_ID     = var.access_key
      AWS_SECRET_ACCESS_KEY = var.secret_key
    }
  }
}

##################################################  API GATEWAY  ##################################################

# https://www.terraform.io/docs/configuration/modules.html
module "api_gateway" {
  source = "../modules/api-gateway"

  name            = "${var.environment}-serverless"
  domain          = var.domain
  api_domain      = "api.${local.domain}"
  stage_name      = "api"
  base_path       = ""
  certificate_arn = data.aws_acm_certificate.primary.arn
}

##################################################  ENDPOINTS  ##################################################

# https://www.terraform.io/docs/configuration/modules.html
module "func_message" {
  source = "../modules/function"

  name         = "message"
  environment  = var.environment
  region       = var.region
  project_path = local.project_path
}

# https://www.terraform.io/docs/configuration/modules.html
module "endpoint_message" {
  source = "../modules/endpoint"

  stage_name           = "api"
  resource             = "message"
  methods              = [ "GET" ]
  enable_cors          = true
  rest_api_id          = module.api_gateway.rest_api_id
  parent_id            = module.api_gateway.v1_resource_id
  function_arns        = [ module.func_message.arn ]
  function_invoke_arns = [ module.func_message.invoke_arn ]
}
