resource "aws_inspector_resource_group" "main" {
  tags {
    Name = "${var.tag}"
  }
}

resource "aws_inspector_assessment_target" "main" {
  name               = "${local.name}-assessment"
  resource_group_arn = "${aws_inspector_resource_group.main.arn}"
}

resource "aws_inspector_assessment_template" "main" {
  name       = "${local.name}"
  target_arn = "${aws_inspector_assessment_target.main.arn}"
  duration   = 3600

  # https://docs.aws.amazon.com/inspector/latest/userguide/inspector_rule-packages.html
  rules_package_arns = [
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gEjTy7T7",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-rExsr2X8",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-R01qwB5Q",
    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gBONHN9h",
  ]
}
