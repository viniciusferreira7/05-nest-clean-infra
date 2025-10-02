terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.5.0"
    }
  }
    backend "s3" {
      bucket   = "05-nest-clean-infra-backend"
      key    = "state/terraform.tfstate"
      region = "us-east-2"
    }
}

provider "aws" {
  region  = "us-east-2"
  profile = var.profile
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "05-nest-clean-infra"
  force_destroy = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    IAC = "True"
  }
}

resource "aws_s3_bucket_acl" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}