resource "aws_api_gateway_rest_api" "serverless" {
  name        = "serverless"
  description = "api gateway for serverless application"
}

########################################  /  ########################################

resource "aws_api_gateway_method" "root" {
  rest_api_id   = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id   = "${aws_api_gateway_rest_api.serverless.root_resource_id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "root" {
  rest_api_id             = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id             = "${aws_api_gateway_method.root.resource_id}"
  http_method             = "${aws_api_gateway_method.root.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.hello-world.invoke_arn}"
}

########################################  /api/v1  ########################################

resource "aws_api_gateway_resource" "api" {
  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
  parent_id   = "${aws_api_gateway_rest_api.serverless.root_resource_id}"
  path_part   = "api"
}

resource "aws_api_gateway_resource" "v1" {
  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
  parent_id   = "${aws_api_gateway_resource.api.id}"
  path_part   = "v1"
}

########################################  /api/v1/hello-world  ########################################

resource "aws_api_gateway_resource" "hello-world" {
  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
  parent_id   = "${aws_api_gateway_resource.v1.id}"
  path_part   = "hello-world"
}

resource "aws_api_gateway_method" "hello-world" {
  rest_api_id   = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id   = "${aws_api_gateway_resource.hello-world.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "hello-world" {
  rest_api_id             = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id             = "${aws_api_gateway_resource.hello-world.id}"
  http_method             = "${aws_api_gateway_method.hello-world.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.hello-world.invoke_arn}"
}

resource "aws_lambda_permission" "hello-world" {
  # AllowExecutionFromAPIGateway
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = "${aws_lambda_function.hello-world.arn}"
  source_arn    = "${aws_api_gateway_deployment.serverless.execution_arn}/*/*"
}

####################################################################################################

resource "aws_api_gateway_deployment" "serverless" {
  depends_on = [
    "aws_api_gateway_integration.root",
    "aws_api_gateway_integration.hello-world",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
  stage_name  = "staging"
}
