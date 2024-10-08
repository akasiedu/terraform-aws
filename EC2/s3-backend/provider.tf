terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.0.0"
    }
  }
}

provider "aws" {
  alias  = "state"
  region = "us-east-1"
}

provider "aws" {
  alias  = "backup"
  region = "us-east-2"
}
