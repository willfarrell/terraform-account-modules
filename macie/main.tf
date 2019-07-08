data "aws_caller_identity" "current" {}

resource "aws_macie_member_account_association" "main" {
  member_account_id = "${data.aws_caller_identity.current.account_id}"
}

# https://docs.aws.amazon.com/macie/latest/userguide/macie-setting-up.html#macie-setting-up-enable
# move to AWS s3 example
//resource "aws_macie_s3_bucket_association" "example" {
//  bucket_name = "tf-macie-example"
//  prefix      = "data"
//
//  classification_type {
//    one_time = "FULL"
//  }
//}
