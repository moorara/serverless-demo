resource "aws_acm_certificate" "primary" {
  validation_method         = "DNS"
  domain_name               = "${var.root_domain}"
  subject_alternative_names = ["${var.sub_domains}"]

  tags {
    Name        = "${var.name}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

resource "aws_route53_record" "root_validation" {
  zone_id = "${var.zone_id}"
  name    = "${aws_acm_certificate.primary.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.primary.domain_validation_options.0.resource_record_type}"
  records = ["${aws_acm_certificate.primary.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "alt_validation" {
  count = "${length(var.sub_domains)}"

  zone_id = "${var.zone_id}"
  name    = "${element(aws_acm_certificate.primary.domain_validation_options.*.resource_record_name, count.index + 1)}"
  type    = "${element(aws_acm_certificate.primary.domain_validation_options.*.resource_record_type, count.index + 1)}"
  records = ["${element(aws_acm_certificate.primary.domain_validation_options.*.resource_record_value, count.index + 1)}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "primary" {
  certificate_arn = "${aws_acm_certificate.primary.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.root_validation.fqdn}",
    "${aws_route53_record.alt_validation.fqdn}",
  ]
}
