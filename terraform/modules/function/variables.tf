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

variable "project_path" {
  type = string
}

variable "runtime" {
  type    = string
  default = "nodejs10.x"
}
