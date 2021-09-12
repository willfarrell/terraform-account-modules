# CloudTrail

- [x] Setup CloudTrail

## Master / Sub-Account
```hcl-terraform
provider "aws" {
  profile = "${local.workspace["profile"]}-${local.workspace["env"]}"
  region  = "us-east-1"
  alias   = "edge"
}

module "edge-logs" {
  source = "git@github.com:willfarrell/terraform-s3-logs-module?ref=v0.4.7"
  name   = "${local.workspace["name"]}-${local.workspace["env"]}-edge"
  providers = {
    aws = aws.edge
  }
  tags   = {
    Name = "Edge Logs"
  }
}

module "cloudtrail" {
  source         = "git@github.com:willfarrell/terraform-account-modules//cloudtrail?ref=v0.0.1"
  name           = local.workspace["name"]
  logging_bucket = module.edge-logs.id
  providers = {
    aws = aws.edge
  }
}
```


## Ref
Inspired by https://github.com/QuiNovas/terraform-aws-cloudtrail
