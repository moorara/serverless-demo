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
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options: dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.main.id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [ each.value.record ]
}

# https://www.terraform.io/docs/providers/aws/r/acm_certificate_validation.html
resource "aws_acm_certificate_validation" "main" {
  certificate_arn = aws_acm_certificate.main.arn
  validation_record_fqdns = [
    for v in aws_route53_record.validation: v.fqdn
  ]
}
