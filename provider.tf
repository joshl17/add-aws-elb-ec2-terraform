terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region  = "eu-west-2"

  default_tags {
    tags = {
      Source = "https://github.com/tryptyx/add-aws-elb-ec2-terraform"
    }
  }
}