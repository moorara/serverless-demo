# https://www.terraform.io/docs/providers/aws/d/route53_zone.html
data "aws_route53_zone" "main" {
  name = "${var.domain}."
}

# https://www.terraform.io/docs/providers/aws/r/acm_certificate.html
resource "aws_acm_certificate" "main" {
  domain_name               = var.cert_domain
  subject_alternative_names = [ var.cert_subdomain ]
  validation_method         = "DNS"

  tags = {
    Name        = var.name
    Environment = var.environment
    Region      = var.region
  }
}

# https://www.terraform.io/docs/providers/aws/r/route53_record.html
resource "aws_route53_record" "validation" {
  zone_id = data.aws_route53_zone.main.id
  name    = aws_acm_certificate.main.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.main.domain_validation_options.0.resource_record_type
  ttl     = 60
  records = [ aws_acm_certificate.main.domain_validation_options.0.resource_record_value ]
}

# https://www.terraform.io/docs/providers/aws/r/route53_record.html
resource "aws_route53_record" "alt_validation" {
  zone_id = data.aws_route53_zone.main.id
  name    = aws_acm_certificate.main.domain_validation_options.1.resource_record_name
  type    = aws_acm_certificate.main.domain_validation_options.1.resource_record_type
  ttl     = 60
  records = [ aws_acm_certificate.main.domain_validation_options.1.resource_record_value ]
}

# https://www.terraform.io/docs/providers/aws/r/acm_certificate_validation.html
resource "aws_acm_certificate_validation" "main" {
  certificate_arn = aws_acm_certificate.main.arn
  validation_record_fqdns = [
    aws_route53_record.validation.fqdn,
    aws_route53_record.alt_validation.fqdn,
  ]
}
