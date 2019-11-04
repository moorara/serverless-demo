# https://www.terraform.io/docs/configuration/outputs.html

output "webapp" {
  value = local.domain
}

output "webapi" {
  value = "api.${local.domain}"
}
