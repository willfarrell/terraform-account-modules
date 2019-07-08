variable "type" {
  type = string
}

variable "master_account_id" {
  type = string
  default = ""
}

variable "sub_accounts" {
  type = "map"

  default = {
    production  = ""
    staging     = ""
    testing     = ""
    development = ""
  }
}
