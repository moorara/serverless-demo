data "aws_route53_zone" "primary" {
  name = "${var.domain}."
}

resource "aws_api_gateway_rest_api" "main" {
  name        = "${var.name}"
  description = "api gateway for serverless application"
}

resource "aws_api_gateway_resource" "v1" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  parent_id   = "${aws_api_gateway_rest_api.main.root_resource_id}"
  path_part   = "v1"
}

# This internally creates a CloudFront distribution to route requests
resource "aws_api_gateway_domain_name" "main" {
  domain_name     = "${var.api_domain}"
  certificate_arn = "${var.certificate_arn}"
}

resource "aws_api_gateway_base_path_mapping" "main" {
  api_id      = "${aws_api_gateway_rest_api.main.id}"
  domain_name = "${aws_api_gateway_domain_name.main.domain_name}"
  stage_name  = "${var.stage_name}"
  base_path   = "${var.base_path}"
}

resource "aws_route53_record" "main" {
  zone_id = "${data.aws_route53_zone.primary.id}"
  name    = "${aws_api_gateway_domain_name.main.domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_api_gateway_domain_name.main.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.main.cloudfront_zone_id}"
    evaluate_target_health = true
  }
}
