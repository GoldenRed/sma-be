




## Policy document for S3 regulating which entities can access t

data "aws_iam_policy_document" "s3_iam_cognito_policy_template" {
  statement {
    sid = "ListYourObjects"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
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



## Policy document for Cognito regulating who can assume the authenticated Cognito role

data "aws_iam_policy_document" "cognito_authenticated_iam_role_template" {
  statement {
    sid = "ListYourObjects"
    effect = "Allow"
    
    principals {
      type = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }
    
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]
    
    condition {
      test = "StringEquals"
      variable = "cognito-identity.amazonaws.com:aud"

      values = [
        aws_cognito_identity_pool.id_pool.id
      ]
    }
    
    condition {
      test = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      
      values = [
        "authenticated"
      ]
    } 
  }
}
