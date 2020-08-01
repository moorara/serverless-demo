# https://www.terraform.io/docs/configuration/terraform.html
terraform {
  # Equivalent to ">= 0.12, < 1.0"
  required_version = "~> 0.12"
  backend "s3" {}
}

# https://www.terraform.io/docs/providers/aws
# https://www.terraform.io/docs/configuration/providers.html#version-provider-versions
provider "aws" {
  # Equivalent to ">= 3.0.0, < 4.0.0"
  version    = "~> 3.0"
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

# https://www.terraform.io/docs/configuration/locals.html
locals {
  env_domain = "${var.environment}.${var.domain}"
  domain     = "${var.environment == "prod" ? var.domain : local.env_domain}"
}

# https://www.terraform.io/docs/configuration/modules.html
module "certificate" {
  source = "../modules/certificate"

  name           = "serverless"
  environment    = var.environment
  region         = var.region
  domain         = var.domain
  cert_domain    = local.domain
  cert_subdomain = "api.${local.domain}"
}
