module "defaults" {
  source = "git@github.com:willfarrell/terraform-defaults-module?ref=v0.1.0"
  tags   = var.default_tags
}

locals {
  account_id               = module.defaults.account_id
  region                   = module.defaults.region
  tags                     = module.defaults.tags
  account_email_local_part = split("@", var.account_email)[0]
  account_email_domain     = split("@", var.account_email)[1]
}

