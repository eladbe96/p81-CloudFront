output "aws_cloudfront_distribution_URL" {
  value       = try(aws_cloudfront_distribution.s3_distribution.domain_name, "")
}