# https://www.terraform.io/docs/configuration/variables.html
# https://www.terraform.io/docs/configuration/types.html

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "domain" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "runtime" {
  type    = string
  default = "nodejs10.x"
}
