# https://www.terraform.io/docs/provisioners/null_resource.html
# https://www.terraform.io/docs/provisioners/local-exec.html
resource "null_resource" "zip" {
  provisioner "local-exec" {
    working_dir = var.project_path
    command     = "node packager ./functions/api/v1/${var.name} ./packages/${var.name}.zip"
  }
}

# https://www.terraform.io/docs/providers/aws/r/lambda_function.html
resource "aws_lambda_function" "function" {
  depends_on = [ "null_resource.zip" ]

  function_name = "${var.environment}-${var.name}"
  description   = "responds to v1/${var.name} endpoint"
  filename      = "${var.project_path}/packages/${var.name}.zip"
  handler       = "index.handler"
  runtime       = var.runtime
  timeout       = 4
  role          = aws_iam_role.function.arn

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }

  tags = {
    Environment = var.environment
    Region      = var.region
  }
}

# https://www.terraform.io/docs/providers/aws/r/iam_role.html
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

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
resource "aws_iam_role_policy" "cloudwatch" {
  name = "cloudwatch_access"
  role = aws_iam_role.function.id

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

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
resource "aws_iam_role_policy" "s3" {
  name = "s3_access"
  role = aws_iam_role.function.id

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
