data "aws_iam_policy_document" "main" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:log-group:/aws/route53/*"]

    principals {
      identifiers = ["route53.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "main" {
  policy_document = data.aws_iam_policy_document.main.json
  policy_name     = "route53-query-logging-policy"
}
