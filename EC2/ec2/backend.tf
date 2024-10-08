terraform {
  backend "s3" {
    bucket = "2560-dev-terraform-project-state"
    dynamodb_table = "2560-dev-terraform-project-state-lock"
    key = "ec2/terraform.tfstate"
    region = "us-east-1"
  }
}