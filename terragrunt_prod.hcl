locals {
  environment = "default"
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "my-testing-backend-eladbe"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
  }
}

inputs = {
  environment = "Terraform"
  bucket_name = "static-web-terraform-eladbe-local${local.environment}"
  product_name = "ProductCloudFront_${local.environment}"
  owner = "Elad Ben-David"
  terraform = "True"
}