data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
  partition  = data.aws_partition.current.partition
}

#####################
# Service - IAM Role
#####################

locals {
  # Role is not required if task definition uses `awsvpc` network mode or if a load balancer is not used
  needs_iam_role  = var.network_mode != "awsvpc" && length(var.load_balancer) > 0
  create_iam_role = var.create_iam_role && local.needs_iam_role
}

data "aws_iam_policy_document" "service_assume" {
  count = local.create_iam_role ? 1 : 0

  statement {
    sid     = "ECSServiceAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "service" {
  count = local.create_iam_role ? 1 : 0

  name = var.iam_role_name
  path = var.iam_role_path

  assume_role_policy = data.aws_iam_policy_document.service_assume[0].json

  tags = merge(var.tags, var.iam_role_tags)
}

data "aws_iam_policy_document" "service" {
  count = local.create_iam_role ? 1 : 0

  statement {
    sid       = "ECSService"
    resources = ["*"]

    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
      "ec2:DescribeTags",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutSubscriptionFilter",
      "logs:PutLogEvents"
    ]
  }

  dynamic "statement" {
    for_each = var.iam_role_statements

    content {
      sid           = try(statement.value.sid, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      effect        = try(statement.value.effect, null)
      resources     = try(statement.value.resources, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

resource "aws_iam_policy" "service" {
  count = local.create_iam_role ? 1 : 0

  name   = var.iam_role_name
  policy = data.aws_iam_policy_document.service[0].json

  tags = merge(var.tags, var.iam_role_tags)
}

resource "aws_iam_role_policy_attachment" "service" {
  count = local.create_iam_role ? 1 : 0

  role       = aws_iam_role.service[0].name
  policy_arn = aws_iam_policy.service[0].arn
}

############################
# Task Execution - IAM Role
############################
locals {
  policy_arn = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy", aws_iam_policy.task_exec[0].arn]
}

data "aws_iam_policy_document" "task_exec_assume" {
  count = var.create_task_exec_iam_role ? 1 : 0

  statement {
    sid     = "ECSTaskExecutionAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_exec" {
  count = var.create_task_exec_iam_role ? 1 : 0

  name               = var.task_exec_iam_role_name
  path               = var.task_exec_iam_role_path
  assume_role_policy = data.aws_iam_policy_document.task_exec_assume[0].json

  tags = merge(var.tags, var.task_exec_iam_role_tags)
}

data "aws_iam_policy_document" "task_exec" {
  count = var.create_task_exec_policy ? 1 : 0

  dynamic "statement" {
    for_each = length(var.task_exec_ssm_param_arns) > 0 ? [1] : []

    content {
      sid       = "GetSSMParams"
      actions   = ["ssm:GetParameters"]
      resources = var.task_exec_ssm_param_arns
    }
  }

  dynamic "statement" {
    for_each = length(var.task_exec_secret_arns) > 0 ? [1] : []

    content {
      sid       = "GetSecrets"
      actions   = ["secretsmanager:GetSecretValue"]
      resources = var.task_exec_secret_arns
    }
  }

  dynamic "statement" {
    for_each = var.task_exec_iam_statements

    content {
      sid       = try(statement.value.sid, null)
      actions   = try(statement.value.actions, null)
      resources = try(statement.value.resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])

        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "task_exec" {
  count = var.create_task_exec_policy ? 1 : 0

  name   = var.task_exec_iam_role_name
  policy = data.aws_iam_policy_document.task_exec[0].json

  tags = merge(var.tags, var.task_exec_iam_role_tags)
}

resource "aws_iam_role_policy_attachment" "task_exec" {
  count = var.create_task_exec_policy ? length(local.policy_arn) : 0

  role       = aws_iam_role.task_exec[0].name
  policy_arn = local.policy_arn[count.index]
}

##################
# Task - IAM Role
##################

data "aws_iam_policy_document" "tasks_assume" {
  count = var.create_tasks_iam_role ? 1 : 0

  # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html#create_task_iam_policy_and_role
  statement {
    sid     = "ECSTasksAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:${local.partition}:ecs:${local.region}:${local.account_id}:*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }
  }
}

resource "aws_iam_role" "tasks" {
  count = var.create_tasks_iam_role ? 1 : 0

  name = var.tasks_iam_role_name
  path = var.tasks_iam_role_path

  assume_role_policy = data.aws_iam_policy_document.tasks_assume[0].json

  tags = merge(var.tags, var.tasks_iam_role_tags)
}

data "aws_iam_policy_document" "tasks" {
  count = var.create_tasks_iam_role ? 1 : 0

  dynamic "statement" {
    for_each = var.task_exec_iam_statements

    content {
      sid       = try(statement.value.sid, null)
      actions   = try(statement.value.actions, null)
      resources = try(statement.value.resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])

        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "tasks" {
  count = var.create_tasks_iam_role ? 1 : 0

  name   = var.tasks_iam_role_name
  policy = data.aws_iam_policy_document.tasks[0].json

  tags = merge(var.tags, var.tasks_iam_role_tags)
}

resource "aws_iam_role_policy_attachment" "tasks" {
  role       = aws_iam_role.tasks[0].name
  policy_arn = aws_iam_policy.tasks[0].arn
}
