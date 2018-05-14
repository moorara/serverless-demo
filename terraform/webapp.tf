resource "aws_s3_bucket" "webapp" {
  bucket = "${local.env_domain}"
  region = "${var.region}"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags {
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${local.env_domain}/*"
    }
  ]
}
POLICY
}

# Build client app production bundle
resource "null_resource" "build_client" {
  depends_on = [
    "aws_s3_bucket.webapp",
  ]

  provisioner "local-exec" {
    working_dir = "${path.module}/../client"
    command     = "yarn run build 1> /dev/null"
  }
}

# Upload client app bundle to S3 bucket
resource "null_resource" "upload_client" {
  depends_on = [
    "null_resource.build_client",
  ]

  provisioner "local-exec" {
    working_dir = "${path.module}/../client/build"
    command     = "aws s3 sync . s3://${aws_s3_bucket.webapp.bucket}"

    environment {
      AWS_ACCESS_KEY_ID     = "${var.access_key}"
      AWS_SECRET_ACCESS_KEY = "${var.secret_key}"
    }
  }
}

resource "aws_cloudfront_distribution" "webapp" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = ["${local.domain}"]

  # This for serving the single-page app from any path
  custom_error_response {
    error_code         = "404"
    response_code      = "200"
    response_page_path = "/index.html"
  }

  origin {
    origin_id   = "${aws_s3_bucket.webapp.bucket}"
    domain_name = "${aws_s3_bucket.webapp.bucket_domain_name}"
  }

  default_cache_behavior {
    target_origin_id       = "${aws_s3_bucket.webapp.bucket}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    compress    = true
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${aws_acm_certificate_validation.primary.certificate_arn}"
    ssl_support_method  = "sni-only"
  }

  tags {
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

resource "aws_route53_record" "webapp" {
  zone_id = "${data.aws_route53_zone.primary.id}"
  name    = "${local.domain}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.webapp.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.webapp.hosted_zone_id}"
    evaluate_target_health = true
  }
}
