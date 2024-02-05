output "aws_s3_bucket" {
  value =  aws_s3_bucket.static-web-terraform-eladbe.id
}

output "s3_domain_name"{
  value = aws_s3_bucket.static-web-terraform-eladbe.bucket_regional_domain_name
}

output "s3_arn"{
  value = aws_s3_bucket.static-web-terraform-eladbe.arn
}