output "arns" {
  value = flatten([aws_iam_role.administrator.*.arn, aws_iam_role.developer.*.arn, aws_iam_role.bastion.*.arn])
}

