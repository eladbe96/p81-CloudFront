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
locals {
  environment = "prod"
  owner = "EladBenDavid"
  terraform = "True"
}

inputs = {
  environment = local.environment 
  bucket_name = "static-web-terraform-eladbe-local${local.environment}"
  product_name = "ProductCloudFront_${local.environment}"
  owner = local.owner
  terraform = local.terraform
}
