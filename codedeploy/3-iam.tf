data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  trusted_entities_service = ["codedeploy.amazonaws.com"]
  policy_name              = coalesce(var.policy_name, var.role_name)

  region     = data.aws_region.current.name
  partition  = data.aws_partition.current.partition
  account_id = data.aws_caller_identity.current.account_id
}

###########
# IAM role
###########

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = local.trusted_entities_service
    }
  }
}

resource "aws_iam_role" "codedeploy_role" {
  name               = var.role_name
  path               = var.role_path
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

#########
# Policy
#########

data "aws_iam_policy_document" "base" {
  statement {
    effect    = "Allow"
    actions   = ["lambda:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "base" {
  name   = local.policy_name
  path   = var.policy_path
  policy = data.aws_iam_policy_document.base.json
}

resource "aws_iam_role_policy_attachment" "base" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = aws_iam_policy.base.arn
}

###############################
# Additional policy statements
###############################

data "aws_iam_policy_document" "additional_inline" {
  count = length(var.policy_statements) > 0 ? 1 : 0

  dynamic "statement" {
    for_each = var.policy_statements

    content {
      sid       = try(statement.value.sid, replace(statement.key, "/[^0-9A-Za-z]*/", ""))
      effect    = try(statement.value.effect, null)
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
        for_each = try(statement.value.condition, [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "additional_inline" {
  count = length(var.policy_statements) > 0 ? 1 : 0

  name   = "${local.policy_name}-inline"
  path   = var.policy_path
  policy = data.aws_iam_policy_document.additional_inline[0].json
}

resource "aws_iam_role_policy_attachment" "additional_inline" {
  count = length(var.policy_statements) > 0 ? 1 : 0

  role       = aws_iam_role.codedeploy_role.name
  policy_arn = aws_iam_policy.additional_inline[0].arn
}
