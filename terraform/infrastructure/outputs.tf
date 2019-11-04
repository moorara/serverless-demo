# https://www.terraform.io/docs/configuration/outputs.html

output "certificate_arn" {
  value = module.certificate.certificate_arn
}
