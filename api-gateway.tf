resource "aws_apigatewayv2_api" "lambda" {
  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "serverless_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }

}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"

  retention_in_days = 30
}

resource "aws_apigatewayv2_integration" "hello_world" {
  for_each = module.lambda_functions

  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = each.value.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

# resource "aws_apigatewayv2_route" "hello_world" {
#   api_id = aws_apigatewayv2_api.lambda.id

#   route_key = "${each.value.methods} /hello"
#   target    = "integrations/${aws_apigatewayv2_integration.hello_world.id}"
# }

resource "aws_lambda_permission" "api_gw" {
  for_each      = var.lambda_map
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

module "lambda_functions" {
  for_each = var.lambda_map
  source   = "./lambda"

  handler          = each.key
  function_name    = each.value.function_name
  language_runtime = each.value.language_runtime
  s3_bucket_id     = aws_s3_bucket.lambda_s3_bucket.id
}

resource "aws_s3_bucket" "lambda_s3_bucket" {
  bucket = "cog-lambda-bucket-exercise-s3"
}
