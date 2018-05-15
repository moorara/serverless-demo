terraform {
  backend "s3" {}
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

data "aws_route53_zone" "primary" {
  name = "${var.domain}."
}

module "certificate" {
  source = "./certificate"

  name        = "serverless"
  environment = "${var.environment}"
  region      = "${var.region}"
  root_domain = "${local.domain}"
  sub_domains = ["api.${local.domain}"]
  zone_id     = "${data.aws_route53_zone.primary.id}"
}

module "func_message" {
  source = "./function"

  name        = "message"
  environment = "${var.environment}"
  region      = "${var.region}"
}
