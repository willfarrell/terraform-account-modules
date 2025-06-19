resource "aws_organizations_organization" "main" {
  feature_set = "ALL"
  enabled_policy_types = [
  "SERVICE_CONTROL_POLICY"]

  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "fms.amazonaws.com",
    "sso.amazonaws.com"
  ]
}


