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
        "ec2.${local.}.amazonaws.com"]
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

