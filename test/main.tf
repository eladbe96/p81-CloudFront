terraform {
  backend "local" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.64.0"
    }
  }
}


resource "aws_s3_bucket" "testing-eladbe" {
  bucket = "testing-eladbe-testing"
  tags = {
    owner = "Eladbe"
  }
}

output "aws_s3_bucket_name" {
  value =  aws_s3_bucket.testing-eladbe.id
}

output "aws_s3_owner" {
  value =  aws_s3_bucket.testing-eladbe.tags
}