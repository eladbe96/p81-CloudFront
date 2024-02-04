output "aws_s3_bucket" {
  value =  aws_s3_bucket.static-web-terraform-eladbe.id
}

output "aws_cloudfront_distribution_URL" {
  value       = try(aws_cloudfront_distribution.s3_distribution.domain_name, "")