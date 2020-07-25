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


resource "aws_iam_policy" "policy" {
  name = "sma-cognito-s3-policy"
  path = "/"
  description = "Policy to allow entry into S3 based on cognito identity pools, specifically to the S3-bucket with the Cognito Identity Pool application name."

  policy = data.aws_iam_policy_document.s3_iam_cognito_policy_template.json
}