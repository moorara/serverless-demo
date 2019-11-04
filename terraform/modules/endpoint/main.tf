##################################################  ENDPOINT  ##################################################

# https://www.terraform.io/docs/providers/aws/r/api_gateway_resource.html
resource "aws_api_gateway_resource" "main" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_id
  path_part   = var.resource
}

# https://www.terraform.io/docs/providers/aws/r/api_gateway_method.html
resource "aws_api_gateway_method" "main" {
  count = length(var.methods)

  rest_api_id   = var.rest_api_id
  resource_id   = aws_api_gateway_resource.main.id
  http_method   = var.methods[count.index]
  authorization = "NONE"
}

# https://www.terraform.io/docs/providers/aws/r/api_gateway_integration.html
resource "aws_api_gateway_integration" "main" {
  count = length(var.methods)

  rest_api_id             = var.rest_api_id
  resource_id             = aws_api_gateway_resource.main.id
  http_method             = element(aws_api_gateway_method.main.*.http_method, count.index)
  integration_http_method = "POST"  // This is for invoking Lambda function
  type                    = "AWS_PROXY"
  uri                     = element(var.function_invoke_arns, count.index)
}

##################################################  ENABLE CORS  ##################################################

# https://www.terraform.io/docs/providers/aws/r/api_gateway_method.html
resource "aws_api_gateway_method" "cors" {
  count = var.enable_cors ? 1 : 0

  rest_api_id   = var.rest_api_id
  resource_id   = aws_api_gateway_resource.main.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# https://www.terraform.io/docs/providers/aws/r/api_gateway_method_response.html
resource "aws_api_gateway_method_response" "cors" {
  count = var.enable_cors ? 1 : 0

  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.cors[0].http_method
  status_code = "200"

  # https://docs.aws.amazon.com/apigateway/api-reference/resource/method-response/#responseModels
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

# https://www.terraform.io/docs/providers/aws/r/api_gateway_integration.html
resource "aws_api_gateway_integration" "cors" {
  count = var.enable_cors ? 1 : 0

  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.cors[0].http_method
  type        = "MOCK"
}

# https://www.terraform.io/docs/providers/aws/r/api_gateway_integration_response.html
resource "aws_api_gateway_integration_response" "cors" {
  count = var.enable_cors ? 1 : 0

  depends_on = [
    "aws_api_gateway_integration.cors",
  ]

  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.cors[0].http_method
  status_code = aws_api_gateway_method_response.cors[0].status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "*"
    "method.response.header.Access-Control-Allow-Methods" = join(",", var.methods)
    "method.response.header.Access-Control-Allow-Headers" = "Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token"
  }
}

##################################################   DEPLOYMENT  ##################################################

# https://www.terraform.io/docs/providers/aws/r/api_gateway_deployment.html
resource "aws_api_gateway_deployment" "main" {
  depends_on = [
    "aws_api_gateway_integration.main",
    "aws_api_gateway_integration.cors",
  ]

  rest_api_id = var.rest_api_id
  stage_name  = "api"
}

# https://www.terraform.io/docs/providers/aws/r/lambda_permission.html
resource "aws_lambda_permission" "main" {
  count = length(var.methods)

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = element(var.function_arns, count.index)
  source_arn    = "${aws_api_gateway_deployment.main.execution_arn}/*/*"
}
