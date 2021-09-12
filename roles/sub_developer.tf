resource "aws_iam_role" "developer" {
  count = var.type != "master" ? 1 : 0
  name  = "developer"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${var.master_account_id}:root"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

}

/*
"Condition": {
  "Bool": {
    "aws:MultiFactorAuthPresent": "true"
  }
}
*/

resource "aws_iam_role_policy_attachment" "developer" {
  count = var.type != "master" ? 1 : 0
  role = aws_iam_role.developer[0].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_policy" "developer_rds" {
  count = var.type != "master" ? 1 : 0
  name   = "developer-rds-policy"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid":"RDSAccess",
      "Effect": "Allow",
      "Action": [
        "rds-db:connect"
      ],
      "Resource":[
        "arn:aws:rds-db::${local.account_id}:dbuser:*/iam_developer"
      ]
    },
    {
      "Sid":"BastionConnect",
      "Effect":"Allow",
      "Action":[
        "ssm:StartSession",
        "ssm:SendCommand"
      ],
      "Resource":[
        "arn:aws:ec2::${local.account_id}:instance/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetConnectionStatus",
        "ssm:DescribeInstanceInformation"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:TerminateSession"
      ],
      "Resource": [
        "arn:aws:ssm::${local.account_id}:session/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "developer_rds" {
  count = var.type != "master" ? 1 : 0
  role = aws_iam_role.developer[0].name
  policy_arn = aws_iam_policy.developer_rds[0].arn
}
