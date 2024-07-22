module "wrapper" {
  source = "../"

  for_each = var.items

  pipeline_name          = try(each.value.pipeline_name, var.defaults.pipeline_name, null)
  codestarconnection_arn = try(each.value.codestarconnection_arn, var.defaults.codestarconnection_arn, null)

  pipeline_type         = try(each.value.pipeline_type, var.defaults.pipeline_type, null)
  execution_mode        = try(each.value.execution_mode, var.defaults.execution_mode, null)
  codepipeline_bucket   = try(each.value.codepipeline_bucket, var.defaults.codepipeline_bucket, null)
  stages                = try(each.value.stages, var.defaults.stages, [])
  trigger               = try(each.value.trigger, var.defaults.trigger, [])
  role_name             = try(each.value.role_name, var.defaults.role_name, null)
  role_path             = try(each.value.role_path, var.defaults.role_path, null)
  policy_name           = try(each.value.policy_name, var.defaults.policy_name, null)
  policy_path           = try(each.value.policy_path, var.defaults.policy_path, null)
  codebuild_project_arn = try(each.value.codebuild_project_arn, var.defaults.codebuild_project_arn, null)
  policy_statements     = try(each.value.policy_statements, var.defaults.policy_statements, {})
  tags                  = try(each.value.tags, var.defaults.tags, {})
}
