data "archive_file" "hello-world" {
  type        = "zip"
  source_dir  = "${path.module}/../functions/api/v1/hello-world"
  output_path = "${path.module}/../packages/hello-world.zip"
}

resource "aws_lambda_function" "hello-world" {
  function_name    = "${var.environment}-hello-world"
  description      = "responds to api/v1/hello-world endpoint"
  filename         = "${path.module}/../packages/hello-world.zip"
  source_code_hash = "${data.archive_file.hello-world.output_base64sha256}"
  handler          = "index.handler"
  runtime          = "${var.runtime}"
  timeout          = 2
  role             = "${aws_iam_role.hello-world.arn}"

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

resource "aws_iam_role" "hello-world" {
  name = "${var.environment}-hello-world"

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

resource "aws_iam_role_policy" "hello-world_cloudwatch" {
  name = "cloudwatch_access"
  role = "${aws_iam_role.hello-world.id}"

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

resource "aws_iam_role_policy" "hello-world_s3" {
  name = "s3_access"
  role = "${aws_iam_role.hello-world.id}"

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
