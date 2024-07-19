########
# Queue
########

###############
# Queue Policy
###############

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

data "aws_iam_policy_document" "this" {
  count = var.create_queue_policy ? 1 : 0

  dynamic "statement" {
    for_each = var.queue_policy_statements

    content {
      sid       = try(statement.value.sid, null)
      actions   = try(statement.value.actions, null)
      effect    = try(statement.value.effect, null)
      resources = try(statement.value.resources, [aws_sqs_queue.this.arn])

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = try(principals.value.identifiers, ["arn:${data.aws_partition.current.id}:iam:${data.aws_caller_identity.current.account_id}:root"])
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

resource "aws_sqs_queue_policy" "this" {
  count = var.create_queue_policy ? 1 : 0

  queue_url = aws_sqs_queue.this.url
  policy    = data.aws_iam_policy_document.this[0].json
}


####################
# Dead Letter Queue
####################

###############
# Queue Policy
###############

data "aws_iam_policy_document" "dlq" {
  count = var.create_dlq && var.create_dlq_queue_policy ? 1 : 0

  dynamic "statement" {
    for_each = var.dlq_queue_policy_statements

    content {
      sid       = try(statement.value.sid, null)
      actions   = try(statement.value.actions, null)
      effect    = try(statement.value.effect, null)
      resources = try(statement.value.resources, [aws_sqs_queue.dlq[0].arn])

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = try(principals.value.identifiers, ["arn:${data.aws_partition.current.id}:iam::${data.aws_caller_identity.current.account_id}:root"])
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

resource "aws_sqs_queue_policy" "dlq" {
  count = var.create_dlq ? 1 : 0

  queue_url = aws_sqs_queue.dlq[0].url
  policy    = data.aws_iam_policy_document.dlq[0].json
}
