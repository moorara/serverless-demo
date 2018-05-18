variable "name" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "root_domain" {
  type = "string"
}

variable "sub_domains" {
  type = "list"
}

variable "zone_id" {
  type = "string"
}

variable "runtime" {
  type    = "string"
  default = "nodejs8.10"
}
