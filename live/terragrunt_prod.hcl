inputs = {
  project_env = "prod"
  environment = "Terraform"
  product_name = "ProductCloudFront"
  owner = "Elad Ben-David"
  terraform = "True"
}

generate "required_providers" {
  path      = "required_providers.tf"
  if_exists = "skip"
  contents  = <<EOF
terraform {
  required_providers {
      aws = {
      source  = "hashicorp/aws"
      version = "5.35.0"
    }
  }
}
EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "eladbe-terraform-state"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}



