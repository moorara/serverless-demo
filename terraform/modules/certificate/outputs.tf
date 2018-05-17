output "certificate_arn" {
  value = "${aws_acm_certificate_validation.primary.certificate_arn}"
}
