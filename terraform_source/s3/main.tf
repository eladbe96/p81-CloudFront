#S3 main.tf
resource "aws_s3_bucket" "static-web-terraform-eladbe" {
  bucket = var.bucket_name
  tags = {
    environment = var.environment
    name = var.product_name
    owner = var.owner
    terraform = var.terraform
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

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}


