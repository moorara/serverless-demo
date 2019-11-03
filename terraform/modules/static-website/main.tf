# https://www.terraform.io/docs/providers/aws/d/route53_zone.html
data "aws_route53_zone" "main" {
  name = "${var.domain}."
}

# https://www.terraform.io/docs/providers/aws/r/s3_bucket.html
resource "aws_s3_bucket" "main" {
  bucket        = var.bucket_name
  region        = var.region
  acl           = "public-read"
  force_destroy = true

  website {
    index_document = var.index_page
    error_document = var.error_page
  }

  tags = {
    Environment = var.environment
    Region      = var.region
  }

  policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
    }
  ]
}
JSON
}

# https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html
resource "aws_cloudfront_distribution" "main" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.index_page
  aliases             = [ var.app_domain ]

  origin {
    origin_id   = aws_s3_bucket.main.bucket
    domain_name = aws_s3_bucket.main.bucket_domain_name
  }

  # This for serving the single-page app from any path
  custom_error_response {
    error_code         = "404"
    response_code      = "200"
    response_page_path = "/${var.index_page}"
  }

  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.main.bucket
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = [ "GET", "HEAD" ]
    cached_methods         = [ "GET", "HEAD" ]

    compress    = true
    min_ttl     = var.cache["min_ttl"]
    default_ttl = var.cache["default_ttl"]
    max_ttl     = var.cache["max_ttl"]

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
    acm_certificate_arn = var.certificate_arn
    ssl_support_method  = "sni-only"
  }

  tags = {
    Environment = var.environment
    Region      = var.region
  }
}

resource "aws_route53_record" "webapp" {
  zone_id = data.aws_route53_zone.main.id
  name    = var.app_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = true
  }
}
