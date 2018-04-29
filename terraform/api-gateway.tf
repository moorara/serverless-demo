resource "aws_api_gateway_rest_api" "serverless" {
  name        = "serverless"
  description = "api gateway for serverless application"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
  parent_id   = "${aws_api_gateway_rest_api.serverless.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id   = "${aws_api_gateway_rest_api.serverless.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hello-world" {
  rest_api_id             = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id             = "${aws_api_gateway_resource.proxy.id}"
  http_method             = "${aws_api_gateway_method.proxy.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.hello-world.invoke_arn}"
}

resource "aws_api_gateway_integration" "hello-world_root" {
  rest_api_id             = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id             = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method             = "${aws_api_gateway_method.proxy_root.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.hello-world.invoke_arn}"
}

resource "aws_api_gateway_deployment" "serverless" {
  depends_on = [
    "aws_api_gateway_integration.hello-world",
    "aws_api_gateway_integration.hello-world_root",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
  stage_name  = "staging"
}

resource "aws_lambda_permission" "api-gateway" {
  statement_id  = "AllowAPIGatewayInvoke"  # AllowExecutionFromAPIGateway
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = "${aws_lambda_function.hello-world.arn}"
  source_arn    = "${aws_api_gateway_deployment.serverless.execution_arn}/*/*"
}
