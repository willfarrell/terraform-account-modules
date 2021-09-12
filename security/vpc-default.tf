data "aws_iam_policy_document" "vpc_flow_logs_publisher_assume_role_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = [
        "vpc-flow-logs.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole"]
  }
}

resource "aws_iam_role" "vpc_flow_logs_publisher" {
  name               = "vpc-default-role"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_logs_publisher_assume_role_policy.json

  tags = var.tags
}

data "aws_iam_policy_document" "vpc_flow_logs_publish_policy" {
  statement {
    actions   = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = [
      "*"]
  }
}

resource "aws_iam_role_policy" "vpc_flow_logs_publish_policy" {
  name = "vpc-default-policy"
  role = aws_iam_role.vpc_flow_logs_publisher.id

  policy = data.aws_iam_policy_document.vpc_flow_logs_publish_policy.json
}

# Regions

module "vpc_baseline_ap-northeast-1" {
  source = "git@github.com:nozaq/terraform-aws-secure-baseline//modules/vpc-baseline?ref=0.17.0"

  providers = {
    aws = aws.ap-northeast-1
  }

  enabled                    = contains(var.regions, "ap-northeast-1")
  vpc_log_group_name         = local.vpc_log_group_name
  vpc_flow_logs_iam_role_arn = aws_iam_role.vpc_flow_logs_publisher.arn
  vpc_log_retention_in_days  = var.logging_retention

  tags = var.tags
}

module "vpc_baseline_ap-northeast-2" {
  source = "git@github.com:nozaq/terraform-aws-secure-baseline//modules/vpc-baseline?ref=0.17.0"

  providers = {
    aws = aws.ap-northeast-2
  }

  enabled                    = contains(var.regions, "ap-northeast-2")
  vpc_log_group_name         = local.vpc_log_group_name
  vpc_flow_logs_iam_role_arn = aws_iam_role.vpc_flow_logs_publisher.arn
  vpc_log_retention_in_days  = var.logging_retention

  tags = var.tags
}

module "vpc_baseline_ap-south-1" {
  source = "git@github.com:nozaq/terraform-aws-secure-baseline//modules/vpc-baseline?ref=0.17.0"

  providers = {
    aws = aws.ap-south-1
  }

  enabled                    = contains(var.regions, "ap-south-1")
  vpc_log_group_name         = local.vpc_log_group_name
  vpc_flow_logs_iam_role_arn = aws_iam_role.vpc_flow_logs_publisher.arn
  vpc_log_retention_in_days  = var.logging_retention

  tags = var.tags
}

module "vpc_baseline_ap-southeast-1" {
  source = "git@github.com:nozaq/terraform-aws-secure-baseline//modules/vpc-baseline?ref=0.17.0"

  providers = {
    aws = aws.ap-southeast-1
  }

  enabled                    = contains(var.regions, "ap-southeast-1")
  vpc_log_group_name         = local.vpc_log_group_name
  vpc_flow_logs_iam_role_arn = aws_iam_role.vpc_flow_logs_publisher.arn
  vpc_log_retention_in_days  = var.logging_retention

  tags = var.tags
}

module "vpc_baseline_ap-southeast-2" {
  source = "git@github.com:nozaq/terraform-aws-secure-baseline//modules/vpc-baseline?ref=0.17.0"

  providers = {
    aws = aws.ap-southeast-2
  }

  enabled                    = contains(var.regions, "ap-southeast-2")
  vpc_log_group_name         = local.vpc_log_group_name
  vpc_flow_logs_iam_role_arn = aws_iam_role.vpc_flow_logs_publisher.arn
  vpc_log_retention_in_days  = var.logging_retention

  tags = var.tags
}

module "vpc_baseline_ca-central-1" {
  source = "git@github.com:nozaq/terraform-aws-secure-baseline//modules/vpc-baseline?ref=0.17.0"

  providers = {
    aws = aws.ca-central-1
  }

  enabled                    = contains(var.regions, "ca-central-1")
  vpc_log_group_name         = local.vpc_log_group_name
  vpc_flow_logs_iam_role_arn = aws_iam_role.vpc_flow_logs_publisher.arn
  vpc_log_retention_in_days  = var.logging_retention

  tags = var.tags
}

module "vpc_baseline_eu-central-1" {
  source = "git@github.com:nozaq/terraform-aws-secure-baseline//modules/vpc-baseline?ref=0.17.0"

  providers = {
    aws = aws.eu-central-1
  }

  enabled                    = contains(var.regions, "eu-central-1")
  vpc_log_group_name         = local.vpc_log_group_name
  vpc_flow_logs_iam_role_arn = aws_iam_role.vpc_flow_logs_publisher.arn
  vpc_log_retention_in_days  = var.logging_retention

  tags = var.tags
}

module "vpc_baseline_eu-north-1" {
  source = "git@github.com:nozaq/terraform-aws-secure-baseline//modules/vpc-baseline?ref=0.17.0"

  providers = {
    aws = aws.eu-north-1
  }

  enabled                    = contains(var.regions, "eu-north-1")
  vpc_log_group_name         = local.vpc_log_group_name
  vpc_flow_logs_iam_role_arn = aws_iam_role.vpc_flow_logs_publisher.arn
  vpc_log_retention_in_days  = var.logging_retention

  tags = var.tags
}

module "vpc_baseline_eu-west-1" {
  source = "git@github.com:nozaq/terraform-aws-secure-baseline//modules/vpc-baseline?ref=0.17.0"

  providers = {
    aws = aws.eu-west-1
  }

  enabled                    = contains(var.regions, "eu-west-1")
  vpc_log_group_name         = local.vpc_log_group_name
  vpc_flow_logs_iam_role_arn = aws_iam_role.vpc_flow_logs_publisher.arn
  vpc_log_retention_in_days  = var.logging_retention

  tags = var.tags
}

module "vpc_baseline_eu-west-2" {
  source = "git@github.com:nozaq/terraform-aws-secure-baseline//modules/vpc-baseline?ref=0.17.0"

  providers = {
    aws = aws.eu-west-2
  }

  enabled                    = contains(var.regions, "eu-west-2")
  vpc_log_group_name         = local.vpc_log_group_name
  vpc_flow_logs_iam_role_arn = aws_iam_role.vpc_flow_logs_publisher.arn
  vpc_log_retention_in_days  = var.logging_retention

  tags = var.tags
}

module "vpc_baseline_eu-west-3" {
  source = "git@github.com:nozaq/terraform-aws-secure-baseline//modules/vpc-baseline?ref=0.17.0"

  providers = {
    aws = aws.eu-west-3
  }

  enabled                    = contains(var.regions, "eu-west-3")
  vpc_log_group_name         = local.vpc_log_group_name
  vpc_flow_logs_iam_role_arn = aws_iam_role.vpc_flow_logs_publisher.arn
  vpc_log_retention_in_days  = var.logging_retention

  tags = var.tags
}

module "vpc_baseline_sa-east-1" {
  source = "git@github.com:nozaq/terraform-aws-secure-baseline//modules/vpc-baseline?ref=0.17.0"

  providers = {
    aws = aws.sa-east-1
  }

  enabled                    = contains(var.regions, "sa-east-1")
  vpc_log_group_name         = local.vpc_log_group_name
  vpc_flow_logs_iam_role_arn = aws_iam_role.vpc_flow_logs_publisher.arn
  vpc_log_retention_in_days  = var.logging_retention

  tags = var.tags
}

module "vpc_baseline_us-east-1" {
  source = "git@github.com:nozaq/terraform-aws-secure-baseline//modules/vpc-baseline?ref=0.17.0"

  providers = {
    aws = aws.us-east-1
  }

  enabled                    = contains(var.regions, "us-east-1")
  vpc_log_group_name         = local.vpc_log_group_name
  vpc_flow_logs_iam_role_arn = aws_iam_role.vpc_flow_logs_publisher.arn
  vpc_log_retention_in_days  = var.logging_retention

  tags = var.tags
}

module "vpc_baseline_us-east-2" {
  source = "git@github.com:nozaq/terraform-aws-secure-baseline//modules/vpc-baseline?ref=0.17.0"

  providers = {
    aws = aws.us-east-2
  }

  enabled                    = contains(var.regions, "us-east-2")
  vpc_log_group_name         = local.vpc_log_group_name
  vpc_flow_logs_iam_role_arn = aws_iam_role.vpc_flow_logs_publisher.arn
  vpc_log_retention_in_days  = var.logging_retention

  tags = var.tags
}

module "vpc_baseline_us-west-1" {
  source = "git@github.com:nozaq/terraform-aws-secure-baseline//modules/vpc-baseline?ref=0.17.0"

  providers = {
    aws = aws.us-west-1
  }

  enabled                    = contains(var.regions, "us-west-1")
  vpc_log_group_name         = local.vpc_log_group_name
  vpc_flow_logs_iam_role_arn = aws_iam_role.vpc_flow_logs_publisher.arn
  vpc_log_retention_in_days  = var.logging_retention

  tags = var.tags
}

module "vpc_baseline_us-west-2" {
  source = "git@github.com:nozaq/terraform-aws-secure-baseline//modules/vpc-baseline?ref=0.17.0"

  providers = {
    aws = aws.us-west-2
  }

  enabled                    = contains(var.regions, "us-west-2")
  vpc_log_group_name         = local.vpc_log_group_name
  vpc_flow_logs_iam_role_arn = aws_iam_role.vpc_flow_logs_publisher.arn
  vpc_log_retention_in_days  = var.logging_retention

  tags = var.tags
}
