output "s3_bucket" {
  value = "${aws_s3_bucket.primary.bucket}"
}

output "api_url" {
  value = "${aws_api_gateway_deployment.serverless.invoke_url}"
}

