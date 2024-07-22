resource "aws_codebuild_project" "this" {
  name          = var.project_name
  description   = var.description
  build_timeout = var.build_timeout


  service_role = aws_iam_role.codebuild.arn
  environment {
    compute_type    = try(var.environment.compute_type, "BUILD_GENERAL1_SMALL")
    image           = try(var.environment.image, "aws/codebuild/amazonlinux2-x86_64-standard:5.0")
    type            = try(var.environment.type, "LINUX_CONTAINER")
    privileged_mode = try(var.environment.privileged_mode, null)

    dynamic "environment_variable" {
      for_each = try(var.environment.variables, [])
      iterator = i

      content {
        name  = i.value.name
        value = i.value.value
        type  = try(i.value.type, "PLAINTEXT")
      }
    }
  }

  source {
    type      = try(var.provider_source.type, "CODEPIPELINE")
    location  = try(var.provider_source.location, "https://pooja-shrestha@bitbucket.org/genesenp/coherence-sample-code.git")
    buildspec = try(var.provider_source.buildspec, "buildspec.yml")
  }

  artifacts {
    type = try(var.artifacts.type, "CODEPIPELINE")
  }

  cache {
    type     = try(var.cache.type, null)
    modes    = try(var.cache.type == "LOCAL" ? var.cache.modes : null, null)
    location = try(var.cache.type == "S3" ? var.cache.location : null, null)
  }

  logs_config {
    cloudwatch_logs {
      group_name  = var.cloudwatch_logs.group_name
      stream_name = var.cloudwatch_logs.stream_name
    }
  }

  tags = var.tags
}
