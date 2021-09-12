
resource "aws_iam_policy" "kms-decrypt" {
  name   = "kms-decrypt-policy"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PreventDecrypt",
      "Action": [
        "kms:decrypt"
      ],
      "Effect": "Deny",
      "Resource": "*"
    }
  ]
}
POLICY
}