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
