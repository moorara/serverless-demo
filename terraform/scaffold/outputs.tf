# https://www.terraform.io/docs/configuration/outputs.html

output "bucket" {
  value = module.webapp.bucket
}
