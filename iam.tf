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