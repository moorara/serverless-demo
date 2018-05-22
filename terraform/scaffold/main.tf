terraform {
  backend "s3" {}
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

data "aws_acm_certificate" "primary" {
  domain   = "${local.domain}"
  statuses = ["ISSUED"]
}

module "webapp" {
  source = "../modules/static-website"

  domain          = "${var.domain}"
  environment     = "${var.environment}"
  region          = "${var.region}"
  app_domain      = "${local.domain}"
  bucket_name     = "${local.env_domain}"
  certificate_arn = "${data.aws_acm_certificate.primary.arn}"
}
