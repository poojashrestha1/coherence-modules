locals {
  execute_command_configuration = {
    logging = "OVERRIDE"
    log_configuration = {
      cloud_watch_log_group_name = try(aws_cloudwatch_log_group.this[0].name)
    }
  }
}

##########
# Cluster
##########

resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  dynamic "configuration" {
    for_each = var.create_cloudwatch_log_group ? [var.cluster_configuration] : []

    content {
      dynamic "execute_command_configuration" {
        for_each = try([merge(local.execute_command_configuration, configuration.value.execute_command_configuration)], [{}])
        iterator = i

        content {
          kms_key_id = try(i.value.kms_key_id, null)
          logging    = try(i.value.logging, "DEFAULT")

          dynamic "log_configuration" {
            for_each = try([i.value.log_configuration], [])

            content {
              cloud_watch_encryption_enabled = try(log_configuration.value.cloud_watch_encryption_enabled, null)
              cloud_watch_log_group_name     = try(log_configuration.value.cloud_watch_log_group_name, null)
              s3_bucket_name                 = try(log_configuration.value.s3_bucket_name, null)
              s3_bucket_encryption_enabled   = try(log_configuration.value.s3_bucket_encryption_enabled, null)
              s3_key_prefix                  = try(log_configuration.value.s3_key_prefix, null)
            }
          }
        }
      }
    }
  }

  dynamic "setting" {
    for_each = flatten([var.cluster_settings])

    content {
      name  = setting.value.name
      value = setting.value.value
    }
  }

  tags = var.tags
}

#############################
# Cluster Capacity Providers
#############################

resource "aws_ecs_cluster_capacity_providers" "this" {
  count = length(var.autoscaling_capacity_providers) > 0 ? 1 : 0

  cluster_name = aws_ecs_cluster.this.name
  capacity_providers = distinct(concat(
    [for k, v in var.autoscaling_capacity_providers : try(v.name, k)]
  ))

  dynamic "default_capacity_provider_strategy" {
    for_each = var.autoscaling_capacity_providers
    iterator = strategy

    content {
      capacity_provider = try(strategy.value.name, strategy.key)
      base              = try(strategy.value.default_capacity_provider_strategy.base, null)
      weight            = try(strategy.value.default_capacity_provider_strategy.weight, null)
    }
  }

  depends_on = [
    aws_ecs_capacity_provider.this
  ]
}

###########################################
# Capacity Provider - Autoscaling Group(s)
###########################################

resource "aws_ecs_capacity_provider" "this" {
  for_each = var.autoscaling_capacity_providers

  name = try(each.value.name, each.key)

  auto_scaling_group_provider {
    auto_scaling_group_arn         = each.value.auto_scaling_group_arn
    managed_termination_protection = each.value.managed_termination_protection

    dynamic "managed_scaling" {
      for_each = try([each.value.managed_scaling], [])

      content {
        instance_warmup_period    = try(managed_scaling.value.instance_warmup_period, null)
        maximum_scaling_step_size = try(managed_scaling.value.maximum_scaling_step_size, null)
        minimum_scaling_step_size = try(managed_scaling.value.minimum_scaling_step_size, null)
        status                    = try(managed_scaling.value.status, null)
        target_capacity           = try(managed_scaling.value.target_capacity, null)
      }
    }
  }

  tags = merge(var.tags, try(each.value.tags, {}))
}
