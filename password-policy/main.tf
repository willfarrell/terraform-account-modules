resource "aws_iam_account_password_policy" "main" {
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_symbols                = true
  require_numbers                = true
  minimum_password_length        = var.minimum_password_length
  allow_users_to_change_password = true
  password_reuse_prevention      = 24
  max_password_age               = var.max_password_age
  hard_expiry                    = var.hard_expiry
}