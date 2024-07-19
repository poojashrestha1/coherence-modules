output "queue_id" {
  description = "The URL for the created Amazon SQS queue"
  value       = try(aws_sqs_queue.this.id, null)
}

output "queue_arn" {
  description = "The ARN of the SQS queue"
  value       = try(aws_sqs_queue.this.arn, null)
}

output "dlq_arn" {
  description = "The ARN of the Dead letter queue"
  value       = try(aws_sqs_queue.dlq[0].arn, null)
}
