
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


resource "aws_iam_role" "authenticated" {
  name = var.cognito_authenticated_iam_role_name  
  assume_role_policy = data.aws_iam_policy_document.cognito_authenticated_iam_role_template.json

  tags = {
    Project = var.project_tag
    Name        = var.cognito_authenticated_iam_role_name
    Environment = var.env
  }
}

resource "aws_cognito_identity_pool_roles_attachment" "main" {
  identity_pool_id = aws_cognito_identity_pool.id_pool.id
  roles = {
    "authenticated" = aws_iam_role.authenticated.arn
  }
}

#role_mapping {}https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_pool_roles_attachment#role_mapping
