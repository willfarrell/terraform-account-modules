module "defaults" {
  source = "git@github.com:willfarrell/terraform-defaults-module?ref=v0.1.0"
  name   = var.name
  tags   = var.default_tags
}

locals {
  account_id = module.defaults.account_id
  region     = module.defaults.region
  name       = "${module.defaults.name}-cloudtrail"
  tags       = module.defaults.tags

  logging_bucket = var.logging_bucket != "" ? var.logging_bucket : "${module.defaults.name}-${terraform.workspace}-edge-logs"
}

