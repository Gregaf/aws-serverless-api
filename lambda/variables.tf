
variable "function_name" {
  description = "Lambda function name."

  type = string
}

variable "language_runtime" {
  description = "The language runtime to use for the Lambda function."

  type = string
}

variable "handler" {
  description = "The handler name to use for the Lambda function."

  type = string
}

variable "s3_bucket_id" {
  description = "The S3 bucket to pull source code from."

  type = string
}
