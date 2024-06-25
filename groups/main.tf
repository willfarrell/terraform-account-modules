# TODO tf v0.12 - https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each
# ${sub_account}-${role}-group

#flatten(split(",",format("%.24s", var.sub_accounts[count.index], "-", join(format("%.24s", var.sub_accounts[count.index], "-"), local.groups))))

resource "aws_iam_group" "groups" {
  count = length(local.groups)

  #name = "${local.groups[count.index]}"
  name = join(
    "",
    [
      upper(
        substr(element(split("-", local.groups[count.index]), 0), 0, 1)
      ),
      substr(element(split("-", local.groups[count.index]), 0), 1, -1),
      upper(
        substr(element(split("-", local.groups[count.index]), 1), 0, 1)
      ),
      substr(element(split("-", local.groups[count.index]), 1), 1, -1),
    ]
  )
}

//# Update after v0.12.0

resource "aws_iam_policy" "groups" {
  count = length(local.groups)
  name  = "${local.groups[count.index]}-policy"

  policy = data.aws_iam_policy_document.groups[count.index].json

}
data "aws_iam_policy_document" "groups" {
  count = length(local.groups)
  statement {
    sid    = "AllowAssumeRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = ["arn:aws:iam::${var.sub_accounts[element(split("-", local.groups[count.index]), 0)]}:role/${element(split("-", local.groups[count.index]), 1)}"]
  }
}
/*
"Condition": {
  "Bool": {
    "aws:MultiFactorAuthPresent": "${local.role_mfa}"
  }
},
*/

resource "aws_iam_group_policy_attachment" "groups" {
  count = length(local.groups)
  group = aws_iam_group.groups[count.index].name
  policy_arn = aws_iam_policy.groups[count.index].arn
}

# Master Account
## Admin
resource "aws_iam_group" "admin" {
  name = "MasterAdmin"
}

resource "aws_iam_group_policy_attachment" "admin" {
  group = aws_iam_group.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "support" {
  group       = aws_iam_group.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
}


## Billing - https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/billing-permissions-ref.html
resource "aws_iam_group" "billing" {
  name = "MasterBilling"
}

resource "aws_iam_group_policy_attachment" "billing" {
  group = aws_iam_group.billing.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

## User
resource "aws_iam_group" "user" {
  name = "User"
}

resource "aws_iam_policy" "user" {
  name = "UserAccess"
  policy = data.aws_iam_policy_document.user.json
}
data "aws_iam_policy_document" "user" {
  statement {
    sid    = "AllowPasswordPolicy"
    effect = "Allow"
    actions = [
      "iam:GetAccountPasswordPolicy"
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowUsersAllActionsForCredentials"
    effect = "Allow"
    actions = [
      "iam:ChangePassword",
      "iam:ListAttachedUserPolicies",
      "iam:ListServiceSpecificCredentials",
      "iam:GenerateServiceLastAccessedDetails",
      "iam:*LoginProfile",
      "iam:*AccessKey*",
      "iam:*SigningCertificate*",
      "iam:*SSHPublicKey*"
    ]
    resources = ["arn:aws:iam::${local.account_id}:user/$${aws:username}"]
  }
  statement {
    sid    = "AllowUsersToSeeStatsOnIAMConsoleDashboard"
    effect = "Allow"
    actions = [
      "iam:GetAccount*",
      "iam:ListAccount*"#wrong?
    ]
    resources = ["*"]
  }
  statement {
    sid    = "AllowUsersToListUsersInConsole"
    effect = "Allow"
    actions = [
      "iam:ListUsers"
    ]
    resources = ["arn:aws:iam::${local.account_id}:user/$${aws:username}"]
  }
  statement {
    sid    = "AllowUsersToListOwnGroupsInConsole"
    effect = "Allow"
    actions = ["iam:ListGroupsForUser"
    ]
    resources = ["arn:aws:iam::${local.account_id}:user/$${aws:username}"]
  }
  statement {
    sid    = "AllowUsersToCreateTheirOwnVirtualMFADevice"
    effect = "Allow"
    actions = ["iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ResyncMFADevice",
      "iam:DeleteVirtualMFADevice",
      "iam:DeactivateMFADevice"
    ]
    resources = ["arn:aws:iam::${local.account_id}:mfa/*",
      "arn:aws:iam::${local.account_id}:user/$${aws:username}"]
  }
  statement {
    sid    = "AllowUsersToListVirtualMFADevices"
    effect = "Allow"
    actions = ["iam:ListMFADevices",
      "iam:ListVirtualMFADevices"
    ]
    resources = ["arn:aws:iam::${local.account_id}:*"]
  }
}


resource "aws_iam_group_policy_attachment" "user" {
group      = aws_iam_group.user.name
policy_arn = aws_iam_policy.user.arn
}

# Terraform
//resource "aws_iam_group" "terraform" {
//  name = "MasterTerraform"
//}
# TODO update policy - s3 read/write, dynamodb read/write
//resource "aws_iam_policy" "terraform" {
//  name        = "TerraformAccess"
//  policy      = <<POLICY
//{
//    "Version": "2012-10-17",
//    "Statement": [
//        {
//            "Sid": "AllowUsersAllActionsForTerraform",
//            "Effect": "Allow",
//            "Action": [
//                "*"
//            ],
//            "Resource": [
//                "arn:aws:iam::${local.account_id}:*"
//            ]
//        }
//    ]
//}
//POLICY
//}
//resource "aws_iam_group_policy_attachment" "terraform" {
//  group      = "${aws_iam_group.terraform.name}"
//  policy_arn = "${aws_iam_policy.terraform.arn}"
//}
