data "archive_file" "function" {
  type        = "zip"
  source_dir  = "${var.functions_path}/api/v1/${var.name}"
  output_path = "${path.root}/packages/${var.name}.zip"
}

resource "aws_lambda_function" "function" {
  function_name    = "${var.environment}-${var.name}"
  description      = "responds to api/v1/${var.name} endpoint"
  filename         = "${data.archive_file.function.output_path}"
  source_code_hash = "${data.archive_file.function.output_base64sha256}"
  handler          = "index.handler"
  runtime          = "${var.runtime}"
  timeout          = 4
  role             = "${aws_iam_role.function.arn}"

  environment {
    variables = {
      ENVIRONMENT = "${var.environment}"
    }
  }

  tags {
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

resource "aws_iam_role" "function" {
  name = "${var.environment}-${var.name}"

  assume_role_policy = <<JSON
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
JSON
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "cloudwatch_access"
  role = "${aws_iam_role.function.id}"

  policy = <<JSON
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
JSON
}

resource "aws_iam_role_policy" "s3" {
  name = "s3_access"
  role = "${aws_iam_role.function.id}"

  policy = <<JSON
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
JSON
}
