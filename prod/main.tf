terraform {
  backend "local" {}
}
variable "environment" {}
variable "bucket_name" {}
variable "product_name" {}
variable "owner" {}
variable "terraform" {}


resource "aws_s3_bucket" "static-web-terraform-eladbe" {
  bucket = var.bucket_name
  tags = {
    environment = var.environment
    name = var.product_name
    owner = var.owner
    terraform = var.terraform
  }
}

resource "aws_s3_bucket_website_configuration" "static-web-eladbe" {
  bucket = aws_s3_bucket.static-web-terraform-eladbe.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3-controls" {
  bucket = aws_s3_bucket.static-web-terraform-eladbe.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "static-web-terraform-eladbe_acl" {
    depends_on = [
        aws_s3_bucket_ownership_controls.s3-controls,
        aws_s3_bucket_public_access_block.allow_public_access,
  ]
  bucket = aws_s3_bucket.static-web-terraform-eladbe.id
  acl    = "public-read-write"
}

resource "aws_s3_bucket_public_access_block" "allow_public_access" {
  bucket = aws_s3_bucket.static-web-terraform-eladbe.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_public_access_from_cloud_front" {
  bucket = aws_s3_bucket.static-web-terraform-eladbe.id
  policy = data.aws_iam_policy_document.allow_public_access_from_cloud_front.json
}

data "aws_iam_policy_document" "allow_public_access_from_cloud_front" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    principals {
      type = "*"
      identifiers = ["*"]
    }

    resources = [
      aws_s3_bucket.static-web-terraform-eladbe.arn,
      "${aws_s3_bucket.static-web-terraform-eladbe.arn}/*",
    ]
    effect = "Allow"
  }
}


locals {
  s3_origin_id = "myS3Origin_${var.environment}"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.static-web-terraform-eladbe.bucket_regional_domain_name
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
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
