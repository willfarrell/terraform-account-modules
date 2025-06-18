variable "type" {
  type    = string
  default = "master"
}

variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "account_email" {
  description = "Organization account email. admin@example.com"
  type = string
}

variable "parent_id" {
  type = string
}

variable "sub_accounts" {
  type = list(string)

  default = [
    "production",
    "staging",
    "testing",
    "development",
  ]
}

