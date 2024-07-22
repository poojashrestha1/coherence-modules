module "wrapper" {
  source = "../"

  for_each = var.items

  project_name      = try(each.value.project_name, var.defaults.project_name, null)
  description       = try(each.value.description, var.defaults.description, null)
  build_timeout     = try(each.value.build_timeout, var.defaults.build_timeout, null)
  provider_source   = try(each.value.provider_source, var.defaults.provider_source, {})
  environment       = try(each.value.environment, var.defaults.environment, {})
  artifacts         = try(each.value.artifacts, var.defaults.artifacts, {})
  cache             = try(each.value.cache, var.defaults.cache, {})
  cloudwatch_logs   = try(each.value.cloudwatch_logs, var.defaults.cloudwatch_logs, {})
  role_name         = try(each.value.role_name, var.defaults.role_name, null)
  role_path         = try(each.value.role_path, var.defaults.role_path, null)
  policy_name       = try(each.value.policy_name, var.defaults.policy_name, null)
  policy_path       = try(each.value.policy_path, var.defaults.policy_path, null)
  policy_statements = try(each.value.policy_statements, var.defaults.policy_statements, {})
  buildspec         = try(each.value.buildspec, var.defaults.buildspec, null)
  tags              = try(each.value.tags, var.defaults.tags, {})
}
