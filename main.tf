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

data "aws_caller_identity" "current" {}
