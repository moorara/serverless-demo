locals {
  env_domain = "${var.environment}.${var.domain}"
  domain     = "${var.environment == "prod" ? var.domain : local.env_domain}"

  client_path  = "${path.module}/../../client"
  project_path = "${path.module}/../.."
}
