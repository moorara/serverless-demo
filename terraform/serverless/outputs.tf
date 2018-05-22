output "webapp" {
  value = "${local.domain}"
}

output "webapi" {
  value = "api.${local.domain}"
}
