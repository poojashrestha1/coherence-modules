data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  trusted_entities_service = ["codepipeline.amazonaws.com"]
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

resource "aws_iam_role" "codepipeline_role" {
  name               = var.role_name
  path               = var.role_path
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

#########
# Policy
#########

data "aws_iam_policy_document" "base" {
  # S3 Policy
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:GetBucketPolicy",
      "s3:GetBucketVersioning",
      "s3:GetObjectVersion",
      "s3:CreateBucket",
      "s3:PutBucketPolicy",
      "s3:PutObjectAcl",
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::codepipeline-${local.region}-*"
    ]
  }

  # IAM Pass Role Policy
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "arn:aws:iam::*:role/service-role/cwe-role-*"
    ]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values = [
        "events.amazonaws.com"
      ]
    }
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values = [
        "codepipeline.amazonaws.com"
      ]
    }
  }

  # CodeBuild Policy
  dynamic "statement" {
    for_each = var.codebuild_project_arn != null ? [1] : []

    content {
      effect = "Allow"
      actions = [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
        "codebuild:BatchGetBuildBatches",
        "codebuild:StartBuildBatch"
      ]
      resources = [
        var.codebuild_project_arn
      ]
    }
  }

  # Codestar Connection Policy
  dynamic "statement" {
    for_each = var.codestarconnection_arn != null ? [1] : []

    content {
      effect = "Allow"
      actions = [
        "codestar-connections:UseConnection"
      ]
      resources = [
        var.codestarconnection_arn
      ]
    }
  }
}

resource "aws_iam_policy" "base" {
  name   = local.policy_name
  path   = var.policy_path
  policy = data.aws_iam_policy_document.base.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "base" {
  role       = aws_iam_role.codepipeline_role.name
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

  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.additional_inline[0].arn
}
