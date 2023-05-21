output "invoke_arn" {
  description = "The invoke arn of a lambda function."

  value = aws_lambda_function.lambda_func.invoke_arn
}
