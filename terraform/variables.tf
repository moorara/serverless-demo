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
  type = "string"
}

variable "region" {
  type = "string"
}

variable "runtime" {
  type    = "string"
  default = "nodejs8.10"
}
