#cloudwatch log group
resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/cloudtrail/cloudtrail-global-logs"
  retention_in_days = 365
}

# 3. Create CloudTrail  with cloudwatch
resource "aws_cloudtrail" "main" {
  name                          = "cloudtrail-global-logs"
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.main.arn}:*"
  cloud_watch_logs_role_arn =   aws_iam_role.cloudtrail_cloudwatch_role.arn
  s3_bucket_name                = var.cloudtrail_logs_name
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  depends_on = [
    aws_cloudwatch_log_group.main,     # <== add this
    aws_iam_role.cloudtrail_cloudwatch_role,
    aws_iam_role_policy_attachment.cloudtrail_cloudwatch_attach
  ]

  tags = {
    Name = "CloudTrail-CloudWatch Global Trail"
  }
}


# Enable GuardDuty
resource "aws_guardduty_detector" "main" {
  enable = true
  finding_publishing_frequency = "FIFTEEN_MINUTES"
  #guardduty will publish his finding after every 15 minutes
}

#  Create an SNS Topic
resource "aws_sns_topic" "security_alerts" {
  name = "security-alerts"
}

#Subscribe your email address to the topic
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email # the email address to receive the alerts
}


# a CloudWatch Metric Filter (for CloudTrail login failures)
resource "aws_cloudwatch_log_metric_filter" "unauthorized_api_calls" {
  name           = "UnauthorizedAPICalls"
  log_group_name = aws_cloudwatch_log_group.main.name

  pattern = "{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }"

  metric_transformation {
    name      = "UnauthorizedAPICalls"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}


# 4. Create a CloudWatch Alarm on suspicious activity
resource "aws_cloudwatch_metric_alarm" "alert_unauth_access" {
  alarm_name          = "Unauthorized API Access"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnauthorizedAPICalls"
  namespace           = "CloudTrailMetrics"
  period              = "300"
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Trigger alert on unauthorized access attempts"
  alarm_actions       = [aws_sns_topic.security_alerts.arn]
}