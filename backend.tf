# you should create a S3 bucket in the region for this VPC before initializing terraform
terraform {
  backend "s3" {
    bucket  = "webhost-statefile-20230608"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    profile = "tf-user3"
    encrypt = true
  }
}

