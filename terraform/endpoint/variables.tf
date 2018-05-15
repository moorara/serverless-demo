variable "stage_name" {
  type = "string"
}

variable "resource" {
  type = "string"
}

variable "methods" {
  type = "list"
}

variable "enable_cors" {
  default = true
}

variable "rest_api_id" {
  type = "string"
}

variable "parent_id" {
  type = "string"
}

variable "function_arns" {
  type = "list"
}

variable "function_invoke_arns" {
  type = "list"
}
