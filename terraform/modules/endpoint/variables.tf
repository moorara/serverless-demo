# https://www.terraform.io/docs/configuration/variables.html
# https://www.terraform.io/docs/configuration/types.html

variable "stage_name" {
  type = string
}

variable "resource" {
  type = string
}

variable "methods" {
  type = list(string)
}

variable "enable_cors" {
  type    = bool
  default = true
}

variable "rest_api_id" {
  type = string
}

variable "parent_id" {
  type = string
}

variable "function_arns" {
  type = list(string)
}

variable "function_invoke_arns" {
  type = list(string)
}
