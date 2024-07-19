locals {

}

resource "aws_sqs_queue" "dlq" {
  count = var.create_dlq ? 1 : 0

  name                              = var.dlq_name
  visibility_timeout_seconds        = try(coalesce(var.dlq_visibility_timeout_seconds, var.visibility_timeout_seconds), null)
  message_retention_seconds         = try(coalesce(var.dlq_message_retention_seconds, var.message_retention_seconds), null)
  max_message_size                  = var.max_message_size
  delay_seconds                     = try(coalesce(var.dlq_delay_seconds, var.delay_seconds), null)
  receive_wait_time_seconds         = try(coalesce(var.dlq_receive_wait_time_seconds, var.receive_wait_time_seconds), null)
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = try(coalesce(var.dlq_content_based_deduplication, var.content_based_deduplication), null)
  kms_master_key_id                 = var.kms_master_key_id
  sqs_managed_sse_enabled           = var.kms_master_key_id != null ? null : var.dlq_sqs_managed_sse_enabled
  kms_data_key_reuse_period_seconds = try(coalesce(var.dlq_kms_data_key_reuse_period_seconds, var.kms_data_key_reuse_period_seconds), null)
  deduplication_scope               = try(coalesce(var.dlq_deduplication_scope, var.deduplication_scope), null)
  fifo_throughput_limit             = var.fifo_throughput_limit

  tags = merge(var.tags, var.dlq_tags)
}
