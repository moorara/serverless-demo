# https://www.terraform.io/docs/configuration/outputs.html

output "rest_api_id" {
  value = aws_api_gateway_rest_api.main.id
}

output "root_resource_id" {
  value = aws_api_gateway_rest_api.main.root_resource_id
}

output "v1_resource_id" {
  value = aws_api_gateway_resource.v1.id
}
