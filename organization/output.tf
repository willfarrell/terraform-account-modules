output "organization_id" {
  value = aws_organizations_organization.main.roots.0.id
}
