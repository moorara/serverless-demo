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

module "api_gateway" {
  source = "./api-gateway"

  name            = "${var.environment}-serverless"
  domain          = "api.${local.domain}"
  stage_name      = "api"
  base_path       = ""
  zone_id         = "${data.aws_route53_zone.primary.id}"
  certificate_arn = "${module.certificate.certificate_arn}"
}

module "func_message" {
  source = "./function"

  name        = "message"
  environment = "${var.environment}"
  region      = "${var.region}"
}

module "endpoint_message" {
  source = "./endpoint"

  stage_name           = "api"
  resource             = "message"
  methods              = ["GET"]
  enable_cors          = true
  rest_api_id          = "${module.api_gateway.rest_api_id}"
  parent_id            = "${module.api_gateway.v1_resource_id}"
  function_arns        = ["${module.func_message.arn}"]
  function_invoke_arns = ["${module.func_message.invoke_arn}"]
}
