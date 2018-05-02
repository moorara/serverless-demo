resource "aws_s3_bucket" "primary" {
  bucket = "${var.region}.${var.environment}.${var.domain}"
  region = "${var.region}"
  acl    = "private"

  tags {
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}
