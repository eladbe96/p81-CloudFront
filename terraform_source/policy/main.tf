resource "aws_s3_bucket_policy" "allow_public_access_from_cloud_front" {
  bucket = var.aws_s3_bucket
  policy = data.aws_iam_policy_document.allow_public_access_from_cloud_front.json
}

data "aws_iam_policy_document" "allow_public_access_from_cloud_front" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]
    condition {
        test     = "StringEquals"
        values   = ["arn:aws:cloudfront::329082085800:distribution/${var.cloudfront_dist_id}"]
        variable = "aws:SourceArn"
    }
    

    principals {
      type = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    resources = [
      var.s3_arn,
      "${var.s3_arn}/*",
    ]
    effect = "Allow"
  }
}
