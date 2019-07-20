resource "aws_guardduty_detector" "main" {
  enable = true
}

resource "aws_guardduty_member" "main" {
  count              = var.type != "master" ? 1 : 0
  account_id         = aws_guardduty_detector.main.account_id
  detector_id        = var.master_id
  email              = var.email
  invite             = true
  invitation_message = "Please accept GuardDuty invitation."
}

resource "aws_guardduty_invite_accepter" "main" {
  count      = var.type != "master" ? 1 : 0
  depends_on = ["aws_guardduty_member.main"]

  detector_id       = aws_guardduty_detector.main.id
  master_account_id = var.master_id
}

# aws_guardduty_ipset
# aws_guardduty_threatintelset

# TODO dashboard
