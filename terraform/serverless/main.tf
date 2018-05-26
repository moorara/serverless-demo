terraform {
  backend "s3" {}
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

data "aws_s3_bucket" "webapp" {
  bucket = "${local.env_domain}"
}

data "aws_acm_certificate" "primary" {
  domain   = "${local.domain}"
  statuses = ["ISSUED"]
}

##################################################  UPLOAD WEBAPP  ##################################################

# Build client app production bundle
resource "null_resource" "build_client" {
  provisioner "local-exec" {
    working_dir = "${local.client_path}"
    command     = "yarn run build 1> /dev/null"
  }
}

# Upload client app bundle to S3 bucket
resource "null_resource" "upload_client" {
  depends_on = ["null_resource.build_client"]

  provisioner "local-exec" {
    working_dir = "${local.client_path}/build"
    command     = "aws s3 sync . s3://${data.aws_s3_bucket.webapp.id}"

    environment {
      AWS_ACCESS_KEY_ID     = "${var.access_key}"
      AWS_SECRET_ACCESS_KEY = "${var.secret_key}"
    }
  }
}

##################################################  API GATEWAY  ##################################################

module "api_gateway" {
  source = "../modules/api-gateway"

  name            = "${var.environment}-serverless"
  domain          = "${var.domain}"
  api_domain      = "api.${local.domain}"
  stage_name      = "api"
  base_path       = ""
  certificate_arn = "${data.aws_acm_certificate.primary.arn}"
}

##################################################  ENDPOINTS  ##################################################

module "func_message" {
  source = "../modules/function"

  name        = "message"
  environment = "${var.environment}"
  region      = "${var.region}"
  funcs_path  = "${local.funcs_path}"
}

module "endpoint_message" {
  source = "../modules/endpoint"

  stage_name           = "api"
  resource             = "message"
  methods              = ["GET"]
  enable_cors          = true
  rest_api_id          = "${module.api_gateway.rest_api_id}"
  parent_id            = "${module.api_gateway.v1_resource_id}"
  function_arns        = ["${module.func_message.arn}"]
  function_invoke_arns = ["${module.func_message.invoke_arn}"]
}
