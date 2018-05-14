resource "aws_acm_certificate" "primary" {
  validation_method = "DNS"
  domain_name       = "${local.domain}"

  subject_alternative_names = [
    "api.${local.domain}",
  ]

  tags {
    Name        = "Serverless"
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

resource "aws_route53_record" "root_validation" {
  zone_id = "${data.aws_route53_zone.primary.id}"
  name    = "${aws_acm_certificate.primary.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.primary.domain_validation_options.0.resource_record_type}"
  records = ["${aws_acm_certificate.primary.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "api_validation" {
  zone_id = "${data.aws_route53_zone.primary.id}"
  name    = "${aws_acm_certificate.primary.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.primary.domain_validation_options.1.resource_record_type}"
  records = ["${aws_acm_certificate.primary.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "primary" {
  certificate_arn = "${aws_acm_certificate.primary.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.root_validation.fqdn}",
    "${aws_route53_record.api_validation.fqdn}",
  ]
}
