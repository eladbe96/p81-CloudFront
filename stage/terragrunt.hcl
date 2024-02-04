remote_state {
  backend = "local"
  config = {
    path = "terraform.tfstate"
  }
}
locals {
  environment = "staging"
  owner = "Elad-Ben-David"
  terraform = "True"
}

inputs = {
  environment = local.environment 
  bucket_name = "static-web-terraform-eladbe-${local.environment}"
  product_name = "ProductCloudFront_${local.environment}"
  owner = local.owner
  terraform = local.terraform
}
