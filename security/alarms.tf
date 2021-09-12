module "alarm_baseline" {
  source = "git@github.com:nozaq/terraform-aws-secure-baseline//modules/alarm-baseline?ref=0.17.0"
  cloudtrail_log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  tags = var.tags
}

# CIS 1.1

variable "alarm_namespace" {
  default = "CISBenchmark"
}

resource "aws_cloudwatch_log_metric_filter" "root_accout_usage" {
  count = 1//var.enabled ? 1 : 0

  name           = "RootAccountUsage"
  pattern        = "{$.userIdentity.type=\"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType !=\"AwsServiceEvent\"}"
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name

  metric_transformation {
    name      = "RootAccountUsage"
    namespace = var.alarm_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "root_accout_usage" {
  count = 1//var.enabled ? 1 : 0

  alarm_name                = "RootAccountUsage"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = aws_cloudwatch_log_metric_filter.root_accout_usage[0].id
  namespace                 = var.alarm_namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Monitoring root account usage."
  alarm_actions             = [module.alarm_baseline.alarm_sns_topic[0].arn]
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []

  tags = var.tags
}

