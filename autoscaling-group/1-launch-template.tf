locals {
  launch_template_name = coalesce(var.launch_template_name, var.name)

  iam_instance_profile_arn  = var.create_iam_instance_profile ? aws_iam_instance_profile.this[0].arn : var.iam_instance_profile_arn
  iam_instance_profile_name = !var.create_iam_instance_profile && var.iam_instance_profile_arn == null ? var.iam_instance_profile_name : null
}

resource "aws_launch_template" "this" {
  count = var.create_launch_template ? 1 : 0

  name        = local.launch_template_name
  description = var.launch_template_description

  ebs_optimized = var.ebs_optimized
  image_id      = var.image_id
  key_name      = var.key_name
  user_data     = var.user_data

  vpc_security_group_ids = length(var.network_interfaces) > 0 ? [] : var.security_groups

  default_version = var.default_version

  dynamic "iam_instance_profile" {
    for_each = local.iam_instance_profile_name != null || local.iam_instance_profile_arn != null ? [1] : []
    content {
      name = local.iam_instance_profile_name
      arn  = local.iam_instance_profile_arn
    }
  }

  instance_type = var.instance_type

  dynamic "tag_specifications" {
    for_each = var.tag_specifications
    content {
      resource_type = tag_specifications.value.resource_type
      tags          = merge(var.tags, tag_specifications.value.tags)
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}
