output "s3_bucket" {
  value = "${aws_s3_bucket.primary.bucket}"
}

output "s3_bucket_domain" {
  value = "${aws_s3_bucket.primary.bucket_domain_name}"
}

output "api_gateway_url" {
  value = "${aws_api_gateway_deployment.serverless.invoke_url}"
}
