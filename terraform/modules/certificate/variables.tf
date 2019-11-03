# https://www.terraform.io/docs/configuration/variables.html
# https://www.terraform.io/docs/configuration/types.html

variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "domain" {
  type = string
}

variable "cert_domain" {
  type = string
}

variable "cert_subdomain" {
  type = string
}
