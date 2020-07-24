
## COGNITO USER POOL

resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name
  tags = {
    Project = var.project_tag
    Name = var.identity_pool_name
    Environment = var.env
  }
}

resource "aws_cognito_user_pool_client" "client_app" {
  name = var.client_app_name
  user_pool_id = aws_cognito_user_pool.user_pool.id
}



## COGNITO IDENTITY POOL

resource "aws_cognito_identity_pool" "id_pool" { 
  identity_pool_name = var.identity_pool_name
  allow_unauthenticated_identities = true


  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.client_app.name
    provider_name           = aws_cognito_user_pool.user_pool.endpoint
  }


  tags = {
    Project = var.project_tag
    Name = var.identity_pool_name
    Environment = var.env
  }
}


## IAM for Cognito
/*
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
*/