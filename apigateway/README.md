# API Gateway

- [x] Enables logging
- [ ] Enabled X-Ray

## Sub-Account
```hcl-terraform
provider "aws" {
  profile = "${local.workspace["profile"]}-${local.workspace["env"]}"
  region  = "us-east-1"
  alias   = "edge"
}

module "apigateway-logs" {
  source = "git@github.com:willfarrell/terraform-account-modules//api-gateway?ref=v0.0.1"
  providers = {
    aws = aws.edge
  }
}
```
