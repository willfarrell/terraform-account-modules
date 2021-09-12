data "aws_caller_identity" "current" {
}

data "aws_region" "current" {}

locals {
  account_id   = data.aws_caller_identity.current.account_id
  region = data.aws_region.current.name
  vpc_log_group_name = "vpc-default"
  config_sns_topic_name = "config"
  invitation_message = "This is an automatic invitation from guardduty."
}

# Ref: https://github.com/nozaq/terraform-aws-secure-baseline