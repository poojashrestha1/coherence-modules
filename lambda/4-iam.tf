locals {
  trusted_entities_service = ["lambda.amazonaws.com"]
  role_name                = coalesce(var.role_name, var.function_name)
  policy_name              = coalesce(var.policy_name, local.role_name)
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

resource "aws_iam_role" "lambda" {
  name               = local.role_name
  path               = var.role_path
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

##################
# Cloudwatch Logs
##################

data "aws_iam_policy_document" "logs" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "logs" {
  name   = "${local.policy_name}-logs"
  path   = var.policy_path
  policy = data.aws_iam_policy_document.logs.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.logs.arn
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

  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.additional_inline[0].arn
}
