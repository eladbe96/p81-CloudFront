output "aws_cloudfront_distribution_URL" {
  value       = try(aws_cloudfront_distribution.s3_distribution.domain_name, "")
}
output "cloudfront_dist_id"{
  value = aws_cloudfront_distribution.s3_distribution.id
}