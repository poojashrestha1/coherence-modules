data "aws_partition" "current" {}

locals {
  role_name   = var.role_name
  policy_name = coalesce(var.policy_name, local.role_name)
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = local.role_name
  path               = var.role_path
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.iam_role_policies

  role       = aws_iam_role.this.name
  policy_arn = each.value
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

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "additional_inline" {
  count = length(var.policy_statements) > 0 ? 1 : 0

  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.additional_inline[0].arn
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_iam_instance_profile ? 1 : 0

  role = aws_iam_role.this.name

  name = local.role_name
  path = var.policy_path

  tags = var.tags
}
