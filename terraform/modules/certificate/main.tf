data "aws_route53_zone" "primary" {
  name = "${var.domain}."
}

resource "aws_acm_certificate" "primary" {
  validation_method         = "DNS"
  domain_name               = "${var.cert_domain}"
  subject_alternative_names = ["${var.cert_subdomain}"]

  tags {
    Name        = "${var.name}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

resource "aws_route53_record" "validation" {
  zone_id = "${data.aws_route53_zone.primary.id}"
  name    = "${aws_acm_certificate.primary.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.primary.domain_validation_options.0.resource_record_type}"
  records = ["${aws_acm_certificate.primary.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "alt_validation" {
  zone_id = "${data.aws_route53_zone.primary.id}"
  name    = "${aws_acm_certificate.primary.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.primary.domain_validation_options.1.resource_record_type}"
  records = ["${aws_acm_certificate.primary.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "primary" {
  certificate_arn = "${aws_acm_certificate.primary.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.validation.fqdn}",
    "${aws_route53_record.alt_validation.fqdn}",
  ]
}
