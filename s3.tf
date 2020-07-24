## S3


resource "aws_s3_bucket" "bucket" {
  bucket_prefix = var.s3_bucket_name_prefix

  versioning {
    enabled = true
  }


  tags = {
    Project = var.project_tag
    Name        = var.s3_bucket_name_prefix
    Environment = var.env
  }
}



## IAM for S3

data "aws_iam_policy_document" "s3_iam_cognito_policy_template" {
  statement {
    sid = "ListYourObjects"
    effect = "Allow"
    actions = [
      "s3:ListBUcket",
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}",
    ]
    condition {
      test = "StringLike"
      variable = "s3:prefix"

      values = [
        "cognito/${aws_cognito_identity_pool.id_pool.identity_pool_name}/&{cognito-identity.amazonaws.com:sub}",
      ]
    }
  }
  statement {
    sid = "ReadWriteDeleteYourObjects"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}/cognito/${aws_cognito_identity_pool.id_pool.identity_pool_name}/&{cognito-identity.amazonaws.com:sub}",
      "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}/cognito/${aws_cognito_identity_pool.id_pool.identity_pool_name}/&{cognito-identity.amazonaws.com:sub}/*",
    ]

  }

}

resource "aws_iam_policy" "policy" {
  name = "sma-cognito-s3-policy"
  path = "/"
  description = "Policy to allow entry into S3 based on cognito identity pools, specifically to the S3-bucket with the Cognito Identity Pool application name."

  policy = data.aws_iam_policy_document.s3_iam_cognito_policy_template.json
}