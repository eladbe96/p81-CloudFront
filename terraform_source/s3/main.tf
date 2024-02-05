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

