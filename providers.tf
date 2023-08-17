terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

//connections.tf
provider "aws" {
  region  = "us-west-2"
}
