terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

###############################################################################
### Create Raw S3 Bucket
###############################################################################
resource "aws_s3_bucket" "bucket-test" {
  bucket = "djl-ap-demo-bucket"
  force_destroy = true
  acl    = "private"
  versioning { enabled = false }

  tags = {
      Name        = "Access Point Demo Bucket"
      Environment = "Dev"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "expire_version"
    enabled = true
    prefix = ""
    expiration {days = 1}
    noncurrent_version_expiration {days = 1}
    abort_incomplete_multipart_upload_days = 1
  }

    lifecycle_rule {
    id      = "delete_version"
    enabled = true      
    prefix = ""
    expiration {expired_object_delete_marker = true}
  }
}

resource "aws_s3_bucket_public_access_block" "bucket-test" {
  bucket = aws_s3_bucket.bucket-test.id

  block_public_acls   = true
  ignore_public_acls  = true
  block_public_policy = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.bucket-test.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["614129417617"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.bucket-test.arn,
      "${aws_s3_bucket.bucket-test.arn}/*",
    ]
  }
}
###############################################################################