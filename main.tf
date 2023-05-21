provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "default terraform project"
      Owner     = "TF Providers"
      Terraform = "Infrastructure managed by terraform"
    }
  }
}

resource "aws_s3_bucket" "lambda_s3_bucket" {
  bucket = "my-lambda-bucket-s3"
}
