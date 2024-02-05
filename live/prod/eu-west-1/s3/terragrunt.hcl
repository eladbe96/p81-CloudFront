terraform {
    source = "../../../../terraform_source/s3/"
}

include {
  path = find_in_parent_folders("terragrunt_prod.hcl")
}

locals {
  region_vars = read_terragrunt_config("../region.hcl")
}

inputs = {
    bucket_name = "static-web-eladbe-${local.region_vars.locals.aws_region}"
}