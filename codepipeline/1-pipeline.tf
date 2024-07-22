resource "aws_codepipeline" "this" {
  name           = var.pipeline_name
  pipeline_type  = var.pipeline_type
  role_arn       = aws_iam_role.codepipeline_role.arn
  execution_mode = var.execution_mode

  artifact_store {
    location = var.codepipeline_bucket
    type     = "S3"
  }

  dynamic "stage" {
    for_each = try(var.stages, [])

    content {
      name = stage.value.name

      dynamic "action" {
        for_each = stage.value.action

        content {
          name             = action.value.name
          category         = action.value.category
          owner            = action.value.owner
          provider         = action.value.provider
          version          = action.value.version
          input_artifacts  = try(action.value.input_artifacts, null)
          output_artifacts = try(action.value.output_artifacts, null)
          role_arn         = try(action.value.role_arn, null)
          run_order        = try(action.value.run_order, null)
          region           = try(action.value.region, null)
          namespace        = try(action.value.namespace, null)
          configuration    = action.value.configuration
        }
      }
    }
  }

  dynamic "trigger" {
    for_each = try(var.trigger, [])

    content {
      provider_type = trigger.value.provider_type

      dynamic "git_configuration" {
        for_each = trigger.value.git_configuration
        iterator = i

        content {
          source_action_name = i.value.source_action_name
          dynamic "pull_request" {
            for_each = try(i.value.pull_request, [])

            content {
              events = pull_request.value.events

              dynamic "branches" {
                for_each = [pull_request.value.branches]

                content {
                  includes = try(branches.value.includes, null)
                  excludes = try(branches.value.excludes, null)
                }
              }

              dynamic "file_paths" {
                for_each = [pull_request.value.file_paths]

                content {
                  includes = try(branches.value.includes, null)
                  excludes = try(branches.value.excludes, null)
                }
              }
            }
          }

          dynamic "push" {
            for_each = try(i.value.push, [])

            content {
              dynamic "branches" {
                for_each = [push.value.branches]

                content {
                  includes = try(branches.value.includes, null)
                  excludes = try(branches.value.excludes, null)
                }
              }

              dynamic "file_paths" {
                for_each = [push.value.file_paths]

                content {
                  includes = try(file_paths.value.includes, null)
                  excludes = try(file_paths.value.excludes, null)
                }
              }
            }
          }
        }
      }
    }
  }

  tags = var.tags

  depends_on = [
    aws_iam_role.codepipeline_role,
    aws_iam_policy.base,
    aws_iam_role_policy_attachment.base,
    aws_iam_policy.additional_inline,
    aws_iam_role_policy_attachment.additional_inline
  ]
}
