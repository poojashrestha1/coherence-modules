data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  trusted_entities_service = ["codebuild.amazonaws.com"]
  role_name                = var.role_name
  policy_name              = coalesce(var.policy_name, local.role_name)

  region     = data.aws_region.current.name
  partition  = data.aws_partition.current.partition
  account_id = data.aws_caller_identity.current.account_id

  cloudwatch_base_arn = "arn:${local.partition}:logs:${local.region}:${local.account_id}"
  codebuild_base_arn  = "arn:${local.partition}:codebuild:${local.region}:${local.account_id}"
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

resource "aws_iam_role" "codebuild" {
  name               = local.role_name
  path               = var.role_path
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

#########
# Policy
#########

data "aws_iam_policy_document" "base" {
  # Cloudwatch Logs Policy
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${local.cloudwatch_base_arn}:log-group:${var.cloudwatch_logs.group_name}",
      "${local.cloudwatch_base_arn}:log-group:${var.cloudwatch_logs.group_name}:*",
      "${local.cloudwatch_base_arn}:log-group:${var.cloudwatch_logs.group_name}:log-stream:${var.cloudwatch_logs.stream_name}"
    ]
  }

  # S3 Policy
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]

    resources = [
      "arn:aws:s3:::codepipeline-${local.region}-*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]

    resources = [
      "${local.codebuild_base_arn}:report-group/${var.project_name}-*"
    ]
  }
}

resource "aws_iam_policy" "base" {
  name        = local.policy_name
  path        = var.policy_path
  policy      = data.aws_iam_policy_document.base.json
  description = "Service role policy for AWS services interacting with CloudWatch Logs, CodeBuild, and S3 resources. Provides limited write access to CloudWatch Logs and CodeBuild in a specified region. Additionally, grants limited read and write access to S3 buckets matching the pattern"

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "base" {
  role       = aws_iam_role.codebuild.name
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

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "additional_inline" {
  count = length(var.policy_statements) > 0 ? 1 : 0

  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.additional_inline[0].arn
}
