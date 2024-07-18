resource "aws_lambda_event_source_mapping" "this" {
  for_each = var.event_source_mapping

  function_name = aws_lambda_function.this[0].arn

  batch_size                         = try(each.value.batch_size, 10)
  enabled                            = try(each.value.enabled, true)
  event_source_arn                   = try(each.value.event_source_arn, null)
  maximum_batching_window_in_seconds = try(each.value.maximum_batching_window_in_seconds, 30)
}

resource "aws_lambda_function_event_invoke_config" "async" {
  for_each = var.function_event_invoke_config

  function_name                = aws_lambda_function.this[0].function_name
  maximum_event_age_in_seconds = try(each.value.maximum_event_age_in_seconds, 60)
  maximum_retry_attempts       = try(each.value.maximum_retry_attempts, 0)
}
