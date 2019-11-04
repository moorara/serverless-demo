# https://www.terraform.io/docs/configuration/outputs.html

output "resource_id" {
  value = aws_api_gateway_resource.main.id
}
