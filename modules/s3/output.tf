# output "s3_bucket_arn" {
#   value = aws_s3_bucket.secure_bucket.arn
# }
output "random_id" {
  value = random_id.bucket_id.hex
}
# output "cloudtrail_logs_id" {
#   value = aws_s3_bucket.cloudtrail_logs.id
# }
# output "cloudtrail_logs_arn" {
#   value = aws_s3_bucket.cloudtrail_logs.arn
# }
output "cloudtrail_logs_name" {
  value = aws_s3_bucket.cloudtrail_logs.bucket
}
output "ec2_role" {
  value = aws_iam_role.ec2_role.name
}
