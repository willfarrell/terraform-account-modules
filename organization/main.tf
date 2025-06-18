resource "aws_organizations_organization" "account" {
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

resource "aws_organizations_organizational_unit" "environments" {
  name      = "environments"
  parent_id = aws_organizations_organization.account.roots.0.id
}

resource "aws_organizations_policy_attachment" "environments" {
  depends_on = [
    aws_organizations_organization.account
  ]
  policy_id = aws_organizations_policy.environments.id
  target_id = aws_organizations_organizational_unit.environments.id
}

resource "aws_organizations_policy" "environments" {
  name        = "org-environments-policy"
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
