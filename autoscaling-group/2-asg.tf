locals {
  launch_template_id      = var.create_launch_template ? aws_launch_template.this[0].id : var.launch_template_id
  launch_template_version = var.create_launch_template && var.launch_template_version == null ? aws_launch_template.this[0].latest_version : var.launch_template_version

  asg_tags = merge(
    var.tags,
    {
      "Name" = coalesce(var.instance_name, var.name)
    }
  )
}

resource "aws_autoscaling_group" "this" {
  name = var.name

  launch_template {
    id      = local.launch_template_id
    version = local.launch_template_version
  }

  vpc_zone_identifier = var.vpc_zone_identifier

  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  desired_capacity_type     = var.desired_capacity_type
  min_elb_capacity          = var.min_elb_capacity
  wait_for_elb_capacity     = var.wait_for_elb_capacity
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  default_cooldown          = var.default_cooldown
  default_instance_warmup   = var.default_instance_warmup
  protect_from_scale_in     = var.protect_from_scale_in
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period

  dynamic "initial_lifecycle_hook" {
    for_each = var.initial_lifecycle_hooks
    iterator = i

    content {
      name                    = i.value.name
      default_result          = try(i.value.default_result, null)
      heartbeat_timeout       = try(i.value.heartbeat_timeout, null)
      lifecycle_transition    = i.value.lifecycle_transition
      notification_metadata   = try(i.value.notification_metadata, null)
      notification_target_arn = try(i.value.notification_target_arn, null)
      role_arn                = try(i.value.role_arn, null)
    }
  }

  timeouts {
    delete = var.delete_timeout
  }

  dynamic "tag" {
    for_each = local.asg_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      load_balancers,
      target_group_arns,
    ]
  }
}
