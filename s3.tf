#create a S3 bucket for central storage that will be accessible from all servers launched from the lauch template
resource "aws_s3_bucket" "central-storage-s3-storage" {
  bucket = var.S3_storage_bucket # Set your desired bucket name
  acl    = "private"

  versioning {
    enabled = true
  }
}

