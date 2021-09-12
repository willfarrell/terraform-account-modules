variable "max_password_age" {
  type = number
  default = 90
}

variable "hard_expiry" {
  type = bool
  default = false
}

variable "minimum_password_length" {
  type = number
  default = 14
}