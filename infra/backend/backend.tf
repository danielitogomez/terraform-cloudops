# DynamoDB table to keep the state locks.
resource "aws_s3_bucket" "terraform_infra" {
  bucket        = "hello1234a-terraform-infra"
  acl           = "private"
  force_destroy = true

  # versioning states
  versioning {
    enabled = true
  }

  # To cleanup old states
  lifecycle_rule {
    enabled = true

    noncurrent_version_expiration {
      days = 30
    }
  }

  tags = {
    Name      = "Bucket for terraform states of hello1234a"
    createdBy = "infra-hello1234a/backend"
  }
}

resource "aws_dynamodb_table" "dynamodb-table" {
  name = "hello1234a-terraform-locks"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name      = "Terraform Lock Table"
    createdBy = "infra-hello1234a/backend"
  }
}
