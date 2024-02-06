# #CloudFront main.tf
locals {
  s3_origin_id = "myS3Origin_${var.environment}"
}

resource "aws_cloudfront_origin_access_control" "oac_for_cloudfront" {
  name                              = "oac-eladbe-for-s3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution"  {
  
  origin {
    domain_name              = var.s3_domain
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.oac_for_cloudfront.id
  }

  enabled             = true

  default_cache_behavior {
    allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods   = ["HEAD", "GET", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
  tags = {
    environment = var.environment
    name = var.product_name
    owner = var.owner
    terraform = var.terraform
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

