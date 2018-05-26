variable "name" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "project_path" {
  type = "string"
}

variable "runtime" {
  type    = "string"
  default = "nodejs8.10"
}
