
#  Create IAM Role and Policy for CloudWatch Logs Delivery 
resource "aws_iam_role" "cloudtrail_cloudwatch_role" {
  name = "CloudTrail_CloudWatch_Logs_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

data "aws_caller_identity" "current" {}# this get your account id dynamically

resource "aws_iam_policy" "cloudtrail_logs_to_cw" {
  name = "CloudTrailDeliveryPolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents"
        ],
      Resource = "${aws_cloudwatch_log_group.main.arn}:*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "cloudtrail_cloudwatch_attach" {
  role       = aws_iam_role.cloudtrail_cloudwatch_role.name
  policy_arn = aws_iam_policy.cloudtrail_logs_to_cw.arn
}