provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "hula-hoop" {
  bucket = "hula-hoop-bucket"
  
  # lifecycle {
  #   prevent_destroy = true
  # }
  
}

resource "aws_dynamodb_table" "security" {
  name = "security"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}