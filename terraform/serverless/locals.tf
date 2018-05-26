locals {
  env_domain = "${var.environment}.${var.domain}"
  domain     = "${var.environment == "prod" ? var.domain : local.env_domain}"

  client_path = "${path.module}/../../client"
  funcs_path  = "${path.module}/../../functions"
}
