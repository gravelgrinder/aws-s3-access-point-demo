terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

provider "aws" {
  alias   = "account2"
  profile = "s3-assume-role-profile"
  region  = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::758373647921:role/DJL-TF-MULTI-ACCT-DELEGATION-ROLE"
  }
}

module "awsacct1" {
  source = "./modules/Acct1"
  providers = {
    aws = aws
  }
}

module "awsacct2" {
  source = "./modules/Acct2"
  providers = {
    aws = aws.account2
  }
}
