terraform {
  backend "s3" {}
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module "certificate" {
  source = "../modules/certificate"

  name           = "serverless"
  environment    = "${var.environment}"
  region         = "${var.region}"
  domain         = "${var.domain}"
  cert_domain    = "${local.domain}"
  cert_subdomain = "api.${local.domain}"
}
