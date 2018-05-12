resource "aws_api_gateway_rest_api" "serverless" {
  name        = "${var.environment}.serverless"
  description = "api gateway for serverless application"
}

resource "aws_api_gateway_domain_name" "serverless" {
  domain_name     = "api.${local.regional_domain}"
  certificate_arn = "${aws_acm_certificate_validation.regional.certificate_arn}"
}

resource "aws_route53_record" "webapi" {
  zone_id = "${data.aws_route53_zone.primary.id}"
  name    = "${aws_api_gateway_domain_name.serverless.domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_api_gateway_domain_name.serverless.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.serverless.cloudfront_zone_id}"
    evaluate_target_health = true
  }
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
  uri                     = "${aws_lambda_function.hello-world.invoke_arn}"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"                                          # This is for invoking Lambda function
}

########################################  /v1  ########################################

resource "aws_api_gateway_resource" "v1" {
  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
  parent_id   = "${aws_api_gateway_rest_api.serverless.root_resource_id}"
  path_part   = "v1"
}

########################################  /v1/hello-world  ########################################

resource "aws_api_gateway_resource" "hello-world" {
  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
  parent_id   = "${aws_api_gateway_resource.v1.id}"
  path_part   = "hello-world"
}

resource "aws_api_gateway_method" "get_hello-world" {
  rest_api_id   = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id   = "${aws_api_gateway_resource.hello-world.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_hello-world" {
  rest_api_id             = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id             = "${aws_api_gateway_resource.hello-world.id}"
  http_method             = "${aws_api_gateway_method.get_hello-world.http_method}"
  uri                     = "${aws_lambda_function.hello-world.invoke_arn}"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"                                                  # This is for invoking Lambda function
}

resource "aws_lambda_permission" "hello-world" {
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
    "aws_api_gateway_integration.get_hello-world",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
  stage_name  = "api"
}

resource "aws_api_gateway_base_path_mapping" "serverless" {
  domain_name = "${aws_api_gateway_domain_name.serverless.domain_name}"
  api_id      = "${aws_api_gateway_rest_api.serverless.id}"
  stage_name  = "${aws_api_gateway_deployment.serverless.stage_name}"
  base_path   = ""
}
