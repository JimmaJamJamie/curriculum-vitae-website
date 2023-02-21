terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket     = "jamie-gear-cv-terraform"
    key        = "terraform.tfstate"
    region     = "eu-west-2"
  }
}

provider "aws" {
  region     = "eu-west-2"
}

provider "aws" {
  alias      = "acm_provider"
  region     = "us-east-1"
}