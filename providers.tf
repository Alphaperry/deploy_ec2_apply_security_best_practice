provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "backend-state-filessdfgdd"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}