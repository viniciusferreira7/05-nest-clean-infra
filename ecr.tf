resource "aws_ecr_repository" "nest-clean-api" {
  name                 = "ci-repositories"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    IAC = "True"
  }
}