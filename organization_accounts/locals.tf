locals {
  account_email_local_part = split("@", var.account_email)[0]
  account_email_domain     = split("@", var.account_email)[1]
}

