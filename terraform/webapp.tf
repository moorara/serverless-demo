resource "aws_s3_bucket" "webapp" {
  bucket = "${local.regional_domain}"
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
      "Resource": "arn:aws:s3:::${local.regional_domain}/*"
    }
  ]
}
POLICY
}

resource "aws_cloudfront_distribution" "webapp" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = ["${local.regional_domain}"]

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
    acm_certificate_arn = "${aws_acm_certificate_validation.regional.certificate_arn}"
    ssl_support_method  = "sni-only"
  }

  tags {
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

resource "aws_route53_record" "webapp" {
  zone_id = "${data.aws_route53_zone.primary.id}"
  name    = "${local.regional_domain}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.webapp.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.webapp.hosted_zone_id}"
    evaluate_target_health = true
  }
}
