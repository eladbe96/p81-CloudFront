terraform {
    source = "../../../../terraform_source/cloudfront/"
}

include {
  path = find_in_parent_folders("terragrunt_prod.hcl")
}

locals {
  region_vars = read_terragrunt_config("../region.hcl")
}

dependency "s3" {
  config_path = "../s3"
}

inputs = {
  s3_domain = dependency.s3.outputs.s3_domain_name
}