
variable "aws_region" {
  description = "AWS region to deploy all resources"

  type    = string
  default = "us-east-1"
}

variable "lambda_map" {
  type = map(any)
}
