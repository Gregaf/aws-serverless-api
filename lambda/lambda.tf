resource "aws_lambda_function" "lambda_func" {
  function_name = var.function_name

  runtime = var.language_runtime
  handler = var.handler

  s3_bucket = var.s3_bucket_id
  s3_key    = aws_s3_object.lambda_func.key

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "lambda_func" {
  name = "/aws/lambda/${aws_lambda_function.lambda_func.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_s3_object" "lambda_func" {
  bucket = var.s3_bucket_id

  key    = "${var.handler}.zip"
  source = "./${var.handler}.zip"
}
