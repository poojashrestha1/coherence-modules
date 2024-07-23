resource "aws_codedeploy_app" "this" {
  name             = var.application_name
  compute_platform = var.compute_platform

  tags = var.tags
}
