resource "aws_autoscaling_policy" "this" {
  for_each = { for k, v in var.scaling_policies : k => v if var.create_scaling_policy }

  name                   = try(each.value.name, each.key)
  autoscaling_group_name = aws_autoscaling_group.this.name

  adjustment_type = try(each.value.adjustment_type, null)
  policy_type     = try(each.value.policy_type, null)

  dynamic "target_tracking_configuration" {
    for_each = try([each.value.target_tracking_configuration], [])

    content {
      target_value     = target_tracking_configuration.value.target_value
      disable_scale_in = try(target_tracking_configuration.value.disable_scale_in, null)

      dynamic "predefined_metric_specification" {
        for_each = try([target_tracking_configuration.value.predefined_metric_specification], [])
        content {
          predefined_metric_type = predefined_metric_specification.value.predefined_metric_type
          resource_label         = try(predefined_metric_specification.value.resource_label, null)
        }
      }
    }
  }
}
