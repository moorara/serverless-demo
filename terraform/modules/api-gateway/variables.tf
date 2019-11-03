# https://www.terraform.io/docs/configuration/variables.html
# https://www.terraform.io/docs/configuration/types.html

variable "name" {
  type = string
}

variable "domain" {
  type = string
}

variable "api_domain" {
  type = string
}

variable "stage_name" {
  type = string
}

variable "base_path" {
  type = string
}

variable "certificate_arn" {
  type = string
}
