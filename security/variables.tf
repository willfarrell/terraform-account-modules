variable "type" {
  type = string
}

variable "name" {
  type = string
}

variable "tags" {
  default = {
    "Terraform" = true
  }
}

variable "regions" {
  type = list(string)
  default = ["us-east-1"]
}

variable "master_account_id" {
  type    = string
  default = ""
}

variable "member_accounts" {
  type = list(object({
    arn   = string
    email = string
    id    = string
    name  = string
  }))

  default = []
}

variable "delivery_frequency" {
  type = string
  default = "One_Hour"
}

variable "publishing_frequency" {
  type = string
  default = "SIX_HOURS"
}

variable "logging_retention" {
  type = number
  default = 365
}

variable "logging_bucket" {
  type    = string
  default = ""
}