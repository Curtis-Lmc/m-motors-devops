provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "M-Motors"
      Environment = "ECF"
      ManagedBy   = "Terraform"
    }
  }
}