output "hello-world_version" {
  value = "${aws_lambda_function.hello-world.version}"
}

output "api-gateway_url" {
  value = "${aws_api_gateway_deployment.serverless.invoke_url}"
}
