terraform {
    source = "../../../terraform_source/cloudfront/"
}

include {
  path = find_in_parent_folders("terragrunt_prod.hcl")
}

locals {
  region_vars = read_terragrunt_config("../region.hcl")
}