variable "access_key" {
  type = "string"
}

variable "secret_key" {
  type = "string"
}

variable "domain" {
  type = "string"
}

variable "environment" {
  type    = "string"
  default = "dev"
}

variable "region" {
  type    = "string"
  default = "us-east-1"
}

variable "runtime" {
  type    = "string"
  default = "nodejs8.10"
}

locals {
  env_domain = "${var.environment}.${var.domain}"
  domain     = "${var.environment == "prod" ? var.domain : local.env_domain}"
}
