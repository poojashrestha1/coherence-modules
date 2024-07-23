resource "aws_codedeploy_deployment_group" "this" {
  app_name               = aws_codedeploy_app.this.name
  deployment_group_name  = var.deployment_group_name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = aws_iam_role.codedeploy_role.arn

  auto_rollback_configuration {
    enabled = var.enable_rollback
    events  = var.rollback_events
  }

  dynamic "ecs_service" {
    for_each = var.compute_platform == "ECS" ? [var.ecs_service] : []

    content {
      cluster_name = ecs_service.value.cluster_name
      service_name = ecs_service.value.service_name
    }
  }

  deployment_style {
    deployment_option = try(var.deployment_option, null)
    deployment_type   = try(var.deployment_type, null)
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = var.termination_wait_time_in_minutes
    }

    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = var.lb_listener_arns
      }
      dynamic "target_group" {
        for_each = var.lb_tg

        content {
          name = target_group.value.name
        }
      }
    }
  }

  tags = merge(var.tags, var.deployment_group_tags)
}
