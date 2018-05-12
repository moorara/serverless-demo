data "archive_file" "message" {
  type        = "zip"
  source_dir  = "${path.module}/../functions/api/v1/message"
  output_path = "${path.module}/../packages/message.zip"
}

resource "aws_lambda_function" "message" {
  function_name    = "${var.environment}-message"
  description      = "responds to api/v1/message endpoint"
  filename         = "${path.module}/../packages/message.zip"
  source_code_hash = "${data.archive_file.message.output_base64sha256}"
  handler          = "index.handler"
  runtime          = "${var.runtime}"
  timeout          = 2
  role             = "${aws_iam_role.message.arn}"

  environment {
    variables = {
      ENVIRONMENT_VAR = "config"
    }
  }

  tags {
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

resource "aws_iam_role" "message" {
  name = "${var.environment}-message"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "message_cloudwatch" {
  name = "cloudwatch_access"
  role = "${aws_iam_role.message.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "message_s3" {
  name = "s3_access"
  role = "${aws_iam_role.message.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::*"
    }
  ]
}
POLICY
}
