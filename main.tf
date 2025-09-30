terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-2"
  profile = var.profile
}

resource "aws_s3_bucket" "terraform-state" {
  bucket        = "05-nest-clean-infra"
  force_destroy = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    IAC = "True"
  }
}