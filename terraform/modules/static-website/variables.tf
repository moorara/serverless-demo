variable "domain" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "bucket_name" {
  type = "string"
}

variable "index_page" {
  type = "string"
}

variable "error_page" {
  type = "string"
}

variable "zone_id" {
  type = "string"
}

variable "certificate_arn" {
  type = "string"
}

variable "cache" {
  type = "map"

  default = {
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }
}
