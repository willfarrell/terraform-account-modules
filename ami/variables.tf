variable "images" {
  type = list(string)
  default = [
    "amzn2-ami-hvm-*-x86_64-bastion",
    "amzn2-ami-hvm-*-x86_64-ec2",
    "amzn2-ami-hvm-*-x86_64-ecs",
    "amzn-ami-hvm-*-x86_64-nat"
  ]
}

variable "sub_accounts" {
  type    = map(string)
  default = {}
}
