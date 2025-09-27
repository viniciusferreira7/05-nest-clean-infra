resource "aws_iam_openid_connect_provider" "oidc-git" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = ["7560d6f40fa55195f740ee2b1b7c0b4836cbe103"]

  tags = {
    IAC = "True"
  }

}

resource "aws_iam_role" "app_runner" {
  name = "app_runner"

  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "Statement1",
        Effect : "Allow",
        Principal : {
          service : "build.apprunner.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "app_runner_ecr_readonly" {
  role       = aws_iam_role.app_runner.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role" "ecr_role" {
  name = "ecr_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Principal" : {
          "Federated" : "arn:aws:iam::794038230254:oidc-provider/token.actions.githubusercontent.com"
        },
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : [
              "sts.amazonaws.com"
            ]
          },
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : [
              "repo:viniciusferreira7/05-nest-clean:ref:refs/heads/main"
            ]
          }
        }
      }
    ]
  })

  tags = {
    IAC = "True"
  }
}

resource "aws_iam_role_policy" "ecr_app_permission" {
  name = "ecr_app_permission"
  role = aws_iam_role.ecr_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "Statement1"
        Action   = "apprunner:*"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "Statement2"
        Action = [
          "iam:PaaRole",
          "iam:CreateServiceLinkedRole"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "Statement3"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:GetAuthorizationToken",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "tf_role" {
  name = "tf_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Principal" : {
          "Federated" : "arn:aws:iam::794038230254:oidc-provider/token.actions.githubusercontent.com"
        },
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : [
              "sts.amazonaws.com"
            ]
          },
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : [
              "repo:viniciusferreira7/05-nest-clean-infra:ref:refs/heads/main"
            ]
          }
        }
      }
    ]
  })

  tags = {
    IAC = "True"
  }

}

resource "aws_iam_role_policy" "tf_app_permission" {
  name = "tf_app_permission"
  role = aws_iam_role.tf_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "Statement1"
        Action   = "erc:*"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid      = "Statement2"
        Action   = "iam:*"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}