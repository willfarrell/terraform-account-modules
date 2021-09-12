resource "aws_macie_member_account_association" "main" {
  count              = var.type != "master" ? 1 : 0
  member_account_id = data.aws_caller_identity.current.account_id
}

/*resource "aws_securityhub_product_subscription" "macie" {
  product_arn = "arn:aws:securityhub:${local.region}::product/aws/macie"
}*/

# https://docs.aws.amazon.com/macie/latest/userguide/macie-setting-up.html#macie-setting-up-enable
# https://www.terraform.io/docs/providers/aws/r/macie_s3_bucket_association.html
# move to AWS s3 example
//resource "aws_macie_s3_bucket_association" "example" {
//  bucket_name = "tf-macie-example"
//  prefix      = "data"
//
//  classification_type {
//    one_time = "FULL"
//  }
//}
