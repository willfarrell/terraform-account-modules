
## Support

resource "aws_iam_role" "support" {
  name               = "AWSSupport"
  assume_role_policy = data.aws_iam_policy_document.support.json
}

resource "aws_iam_role_policy_attachment" "support" {
  role = aws_iam_role.support.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
}

data "aws_iam_policy_document" "support" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
    actions = ["sts:AssumeRole"]
  }
}