output "arns" {
  value = flatten([aws_iam_role.administrator.*.arn, aws_iam_role.developer.*.arn, aws_iam_role.bastion.*.arn])
}

output "bastion_arns" {
  value = aws_iam_role.bastion.*.arn
}

output "ecr_arns" {
  value = aws_iam_role.ecr.*.arn
}

output "developer_role_name" {
  count = var.type != "master" ? 1 : 0
  value = aws_iam_role.developer[0].name
}

output "admin_role_name" {
  count = var.type != "master" ? 1 : 0
  value = aws_iam_role.administrator[0].name
}