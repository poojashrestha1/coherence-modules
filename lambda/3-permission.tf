resource "aws_lambda_permission" "this" {
  for_each = var.allowed_triggers

  function_name = aws_lambda_function.this[0].function_name

  statement_id = try(each.value.statement_id, each.key)
  action       = try(each.value.action, "lambda:InvokeFunction")
  principal    = try(each.value.principal, format("%s.amazonaws.com", try(each.value.service, "")))
  source_arn   = try(each.value.source_arn, null)
}
