# https://www.terraform.io/docs/configuration/outputs.html

output "bucket" {
  value = aws_s3_bucket.main.bucket
}
