module "wrapper" {
  source = "../"

  for_each = var.items

  application_name                 = try(each.value.application_name, var.defaults.application_name, null)
  compute_platform                 = try(each.value.compute_platform, var.defaults.compute_platform, null)
  deployment_group_name            = try(each.value.deployment_group_name, var.defaults.deployment_group_name, null)
  service_role_arn                 = try(each.value.service_role_arn, var.defaults.service_role_arn, null)
  deployment_group_tags            = try(each.value.deployment_group_tags, var.defaults.deployment_group_tags, {})
  enable_rollback                  = try(each.value.enable_rollback, var.defaults.enable_rollback, null)
  rollback_events                  = try(each.value.rollback_events, var.defaults.rollback_events, [])
  ecs_service                      = try(each.value.ecs_service, var.defaults.ecs_service, {})
  lb_listener_arns                 = try(each.value.lb_listener_arns, var.defaults.lb_listener_arns, [])
  lb_tg                            = try(each.value.lb_tg, var.defaults.lb_tg, [])
  deployment_option                = try(each.value.deployment_option, var.defaults.deployment_option, null)
  deployment_type                  = try(each.value.deployment_type, var.defaults.deployment_type, null)
  termination_wait_time_in_minutes = try(each.value.termination_wait_time_in_minutes, var.defaults.termination_wait_time_in_minutes, null)
  role_name                        = try(each.value.role_name, var.defaults.role_name, null)
  role_path                        = try(each.value.role_path, var.defaults.role_path, null)
  policy_name                      = try(each.value.policy_name, var.defaults.policy_name, null)
  policy_path                      = try(each.value.policy_path, var.defaults.policy_path, null)
  policy_statements                = try(each.value.policy_statements, var.defaults.policy_statements, {})
  tags                             = try(each.value.tags, var.defaults.tags, {})
}
