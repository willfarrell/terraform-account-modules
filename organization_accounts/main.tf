resource "aws_organizations_organizational_unit" "environments" {
  name      = var.name
  parent_id = var.parent_id
}

resource "aws_organizations_policy_attachment" "environments" {
  policy_id = aws_organizations_policy.environments.id
  target_id = aws_organizations_organizational_unit.environments.id
}

resource "aws_organizations_policy" "environments" {
  name        = "org-${var.name}-policy"
  description = "Allows access to every operation"

  content = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "*",
    "Resource": "*"
  }
}
POLICY
}

# Docs: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_create.html
# To set password go to root sign up and enter email
resource "aws_organizations_account" "environment" {
  count                      = length(var.sub_accounts)
  name                       = var.sub_accounts[count.index]
  email                      = "${local.account_email_local_part}+${var.sub_accounts[count.index]}@${local.account_email_domain}"
  iam_user_access_to_billing = "DENY"
  parent_id                  = aws_organizations_organizational_unit.environments.id

  lifecycle {
    ignore_changes = [iam_user_access_to_billing, role_name] # https://www.terraform.io/docs/providers/aws/r/organizations_account.html#import
  }

  /*tags = merge(
  local.tags,
  {
    "Name" = var.sub_accounts[count.index]
  }
  )*/
}
