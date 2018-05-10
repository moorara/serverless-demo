locals {
  regional_domain = "${var.region}.${var.environment}.${var.domain}"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

data "aws_route53_zone" "primary" {
  name = "${var.domain}."
}
