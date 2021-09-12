resource "aws_cloudtrail" "default" {
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.cloudtrail.arn
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail.arn
  enable_log_file_validation    = true
  include_global_service_events = true
  is_multi_region_trail         = true
  kms_key_id                    = aws_kms_key.cloudtrail.arn
  name                          = var.name
  s3_bucket_name                = var.logging_bucket
  sns_topic_name                = aws_sns_topic.cloudtrail.name

  tags = merge(
  var.tags,
  {
    Name = var.name
  }
  )
}

// TODO add in Insights
// https://github.com/terraform-providers/terraform-provider-aws/issues/10988


# CloudWatch
data "aws_iam_policy_document" "cloudwatch_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "cloudtrail" {
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_assume_role.json
  name               = "cloudtrail-role"
}

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "cloudtrail"
  retention_in_days = var.logging_retention
}

data "aws_iam_policy_document" "cloudtrail_logs" {
  statement {
    actions   = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      aws_cloudwatch_log_group.cloudtrail.arn,
    ]
    sid       = "AWSCloudTrailLogging"
  }
}

resource "aws_iam_role_policy" "cloudtrail" {
  name   = "cloudtrail-logs"
  policy = data.aws_iam_policy_document.cloudtrail_logs.json
  role   = aws_iam_role.cloudtrail.id
}


# SNS
resource "aws_sns_topic" "cloudtrail" {
  name = var.name
}

data "aws_iam_policy_document" "cloudtrail_sns" {
  statement {
    actions   = [
      "sns:Publish",
    ]
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
      type        = "Service"
    }
    resources = [
      aws_sns_topic.cloudtrail.arn,
    ]
    sid       = "CloudTrail SNS Policy"
  }
}

resource "aws_sns_topic_policy" "cloudtrail" {
  arn    = aws_sns_topic.cloudtrail.arn
  policy = data.aws_iam_policy_document.cloudtrail_sns.json
}

# --------------------------------------------------------------------------------------------------
# KMS Key to encrypt CloudTrail events.
# The policy was derived from the default key policy descrived in AWS CloudTrail User Guide.
# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/default-cmk-policy.html
# --------------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "cloudtrail_kms" {
  policy_id = "Key policy created by CloudTrail"

  statement {
    sid = "Enable IAM User Permissions"

    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${local.account_id}:root"
      ]
    }
    actions   = [
      "kms:*"]
    resources = [
      "*"]
  }

  statement {
    sid       = "Allow CloudTrail to encrypt logs"
    principals {
      type        = "Service"
      identifiers = [
        "cloudtrail.amazonaws.com"]
    }
    actions   = [
      "kms:GenerateDataKey*"]
    resources = [
      "*"]
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = [
        "arn:aws:cloudtrail:*:${local.account_id}:trail/*"]
    }
  }

  statement {
    sid       = "Allow CloudTrail to describe key"
    principals {
      type        = "Service"
      identifiers = [
        "cloudtrail.amazonaws.com"]
    }
    actions   = [
      "kms:DescribeKey"]
    resources = [
      "*"]
  }

  statement {
    sid       = "Allow principals in the account to decrypt log files"
    principals {
      type        = "AWS"
      identifiers = [
        "*"]
    }
    actions   = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]
    resources = [
      "*"]
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [
        "${local.account_id}"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = [
        "arn:aws:cloudtrail:*:${local.account_id}:trail/*"]
    }
  }

  statement {
    sid       = "Allow alias creation during setup"
    principals {
      type        = "AWS"
      identifiers = [
        "*"]
    }
    actions   = [
      "kms:CreateAlias"]
    resources = [
      "*"]
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = [
        "ec2.${local.region}.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [
        "${local.account_id}"]
    }
  }

  statement {
    sid       = "Enable cross account log decryption"
    principals {
      type        = "AWS"
      identifiers = [
        "*"]
    }
    actions   = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]
    resources = [
      "*"]
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [
        "${local.account_id}"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = [
        "arn:aws:cloudtrail:*:${local.account_id}:trail/*"]
    }
  }
}

resource "aws_kms_key" "cloudtrail" {
  description             = "A KMS key to encrypt CloudTrail events."
  deletion_window_in_days = 7
  enable_key_rotation     = "true"

  policy = data.aws_iam_policy_document.cloudtrail_kms.json

  tags = var.tags
}

