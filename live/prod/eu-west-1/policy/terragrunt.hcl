terraform {
    source = "../../../../terraform_source/policy/"
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

dependency "cloudfront" {
  config_path = "../cloudfront"
}

inputs = {
  aws_s3_bucket = dependency.s3.outputs.aws_s3_bucket
  s3_arn = dependency.s3.outputs.s3_arn
  cloudfront_dist_id = dependency.cloudfront.outputs.cloudfront_dist_id
}