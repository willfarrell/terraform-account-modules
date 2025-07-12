resource "aws_cloudtrail" "default" {
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.cloudtrail.arn
  cloud_watch_logs_role_arn     = aws_iam_role.cloudwatch_logs.arn
  enable_log_file_validation    = true
  include_global_service_events = true
  is_multi_region_trail         = true

  kms_key_id                    = aws_kms_key.cloudtrail.arn
  name           = local.name
  s3_bucket_name = local.logging_bucket
  sns_topic_name = aws_sns_topic.cloudtrail.name

  tags = merge(
    local.tags,
    {
      Name = local.name
    }
  )
}

output "arn" {
  value = aws_cloudtrail.default.arn
}

# TODO add in Insights
# https://github.com/terraform-providers/terraform-provider-aws/issues/10988
