
#IAM policy for S3 access (read-only)
data "aws_iam_policy_document" "s3_read_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.secure_bucket.arn,# bucket itself arn
      "${aws_s3_bucket.secure_bucket.arn}/*"#arn of all objects inside the bucket
    ]
  }
}

resource "aws_iam_policy" "s3_read_policy" {
  name   = "S3ReadPolicy-${random_id.bucket_id.hex}"
  policy = data.aws_iam_policy_document.s3_read_policy.json
}

#IAM Role for EC2 with trust policy
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "EC2ReadS3Role-${random_id.bucket_id.hex}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

#Attach S3 read policy to role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

data "aws_caller_identity" "current" {}# this get your account id dynamically

# Allow CloudTrail to write to S3 bucket
resource "aws_s3_bucket_policy" "cloudtrail_logs_policy" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      #The first statement allows cloudtrail to read bucket acl
      {
        Sid       = "AWSCloudTrailAclCheck"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:GetBucketAcl"
        Resource  = aws_s3_bucket.cloudtrail_logs.arn
      },
      #allows cloudtrail to write log files
      {
        Sid       = "AWSCloudTrailWrite"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.cloudtrail_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

