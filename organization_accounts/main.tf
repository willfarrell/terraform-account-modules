
# Docs: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_create.html
# To set password go to root sign up and enter email
resource "aws_organizations_account" "environment" {
  count                      = length(var.sub_accounts)
  name                       = var.sub_accounts[count.index]
  email                      = "${local.account_email_local_part}+${var.sub_accounts[count.index]}@${local.account_email_domain}"
  iam_user_access_to_billing = "DENY"
  parent_id                  = var.parent_id

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
