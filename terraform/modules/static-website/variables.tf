# https://www.terraform.io/docs/configuration/variables.html
# https://www.terraform.io/docs/configuration/types.html

variable "domain" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "app_domain" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "index_page" {
  type    = string
  default = "index.html"
}

variable "error_page" {
  type    = string
  default = "error.html"
}

variable "cache" {
  type = map(number)
  default = {
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }
}
