output "bucket" {
  value = "${aws_s3_bucket.webapp.bucket}"
}

output "webapp" {
  value = "${local.regional_domain}"
}

output "webapi" {
  value = "api.${local.regional_domain}"
}
