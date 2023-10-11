terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#configure the aws provider
provider "aws" {
  region                   = var.region
  shared_config_files      = ["/Users/lz233/.aws/config"]
  shared_credentials_files = ["/Users/lz233/.aws/credentials"]
  profile                  = "tf-user3"
}