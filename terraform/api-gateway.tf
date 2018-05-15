resource "aws_api_gateway_rest_api" "serverless" {
  name        = "${var.environment}.serverless"
  description = "api gateway for serverless application"
}

resource "aws_api_gateway_domain_name" "serverless" {
  domain_name     = "api.${local.domain}"
  certificate_arn = "${aws_acm_certificate_validation.primary.certificate_arn}"
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

/* resource "aws_api_gateway_method" "get_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id   = "${aws_api_gateway_rest_api.serverless.root_resource_id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_root" {
  rest_api_id             = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id             = "${aws_api_gateway_method.get_root.resource_id}"
  http_method             = "${aws_api_gateway_method.get_root.http_method}"
  uri                     = "${module.func_message.invoke_arn}"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"  # This is for invoking Lambda function
} */

########################################  /v1  ########################################

resource "aws_api_gateway_resource" "v1" {
  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
  parent_id   = "${aws_api_gateway_rest_api.serverless.root_resource_id}"
  path_part   = "v1"
}

########################################  /v1/message  ########################################

resource "aws_api_gateway_resource" "message" {
  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
  parent_id   = "${aws_api_gateway_resource.v1.id}"
  path_part   = "message"
}

resource "aws_api_gateway_method" "get_message" {
  rest_api_id   = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id   = "${aws_api_gateway_resource.message.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "options_message" {
  rest_api_id   = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id   = "${aws_api_gateway_resource.message.id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_message" {
  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id = "${aws_api_gateway_resource.message.id}"
  http_method = "${aws_api_gateway_method.options_message.http_method}"
  status_code = "200"

  response_models {
    "application/json" = "Empty"
  }

  response_parameters {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration" "get_message" {
  rest_api_id             = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id             = "${aws_api_gateway_resource.message.id}"
  http_method             = "${aws_api_gateway_method.get_message.http_method}"
  uri                     = "${module.func_message.invoke_arn}"
  type                    = "AWS_PROXY"
  integration_http_method = "POST"                                              # This is for invoking Lambda function
}

resource "aws_api_gateway_integration" "options_message" {
  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id = "${aws_api_gateway_resource.message.id}"
  http_method = "${aws_api_gateway_method.options_message.http_method}"
  type        = "MOCK"
}

resource "aws_api_gateway_integration_response" "options_message" {
  depends_on = [
    "aws_api_gateway_integration.options_message",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.serverless.id}"
  resource_id = "${aws_api_gateway_resource.message.id}"
  http_method = "${aws_api_gateway_method.options_message.http_method}"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'${local.domain}'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,PATCH,DELETE,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
  }
}

resource "aws_lambda_permission" "message" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = "${module.func_message.arn}"
  source_arn    = "${aws_api_gateway_deployment.serverless.execution_arn}/*/*"
}

####################################################################################################

resource "aws_api_gateway_deployment" "serverless" {
  depends_on = [
    # "aws_api_gateway_integration.root",
    "aws_api_gateway_integration.get_message",

    "aws_api_gateway_integration.options_message",
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
