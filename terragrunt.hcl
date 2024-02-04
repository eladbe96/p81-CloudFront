locals {
  environment = "default"
}

inputs = {
  environment = local.environment
  bucket_name = "static-web-terraform-eladbe-${local.environment}"
}