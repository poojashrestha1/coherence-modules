resource "aws_sqs_queue_redrive_policy" "this" {
  count = !var.create_dlq && length(var.redrive_policy) > 0 ? 1 : 0

  queue_url      = aws_sqs_queue.this.url
  redrive_policy = jsonencode(var.redrive_policy)
}

resource "aws_sqs_queue_redrive_policy" "dlq" {
  count = var.create_dlq ? 1 : 0

  queue_url = aws_sqs_queue.this.url
  redrive_policy = jsonencode(
    merge({
      maxReceiveCount     = 1
      deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
      },
      var.redrive_policy
    )
  )
}

resource "aws_sqs_queue_redrive_allow_policy" "dlq" {
  count = var.create_dlq && var.create_dlq_redrive_allow_policy ? 1 : 0

  queue_url = aws_sqs_queue.dlq[0].url

  redrive_allow_policy = jsonencode(merge(
    {
      redrivePermission = "byQueue",
      sourceQueueArns   = [aws_sqs_queue.this.arn]
    },
    var.redrive_allow_policy)
  )
}
