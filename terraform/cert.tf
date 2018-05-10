resource "aws_acm_certificate" "regional" {
  validation_method = "DNS"
  domain_name       = "${local.regional_domain}"

  subject_alternative_names = [
    "api.${local.regional_domain}",
  ]

  tags {
    Name        = "Serverless"
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

resource "aws_route53_record" "region_validation" {
  zone_id = "${data.aws_route53_zone.primary.id}"
  name    = "${aws_acm_certificate.regional.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.regional.domain_validation_options.0.resource_record_type}"
  records = ["${aws_acm_certificate.regional.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "api_validation" {
  zone_id = "${data.aws_route53_zone.primary.id}"
  name    = "${aws_acm_certificate.regional.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.regional.domain_validation_options.1.resource_record_type}"
  records = ["${aws_acm_certificate.regional.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "regional" {
  certificate_arn = "${aws_acm_certificate.regional.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.region_validation.fqdn}",
    "${aws_route53_record.api_validation.fqdn}",
  ]
}
