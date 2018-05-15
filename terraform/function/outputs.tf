output "arn" {
  value = "${aws_lambda_function.function.arn}"
}

output "invoke_arn" {
  value = "${aws_lambda_function.function.invoke_arn}"
}

output "version" {
  value = "${aws_lambda_function.function.version}"
}
