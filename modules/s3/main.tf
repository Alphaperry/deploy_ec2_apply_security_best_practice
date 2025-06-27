# a private S3 bucket
resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "secure_bucket" {
  bucket = "secure-ec2-bucket-${random_id.bucket_id.hex}"

  tags = {
    Name = "Secure EC2 S3 Bucket"
  }
}


resource "aws_s3_bucket_public_access_block" "secure_block" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 1. Create S3 Bucket for CloudTrail Logs
resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "cloudtrail-logs-secure-${random_id.bucket_id.hex}"
  
  tags = {
    Name = "CloudTrail Logs Bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "secure_logs_block" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_versioning" "cloudtrail_logs" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_logs" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail_logs" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  rule {
    id     = "cloudtrail-log-lifecycle"
    status = "Enabled"

    # Use filter to target only CloudTrail logs in the AWSLogs/ folder
    filter {
      prefix = "AWSLogs/"
    }

    # Transition to GLACIER after 30 days
    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    # Expire objects after 365 days
    expiration {
      days = 365
    }
  }
}
