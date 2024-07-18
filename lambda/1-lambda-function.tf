# data "archive_file" "my_lambda" {
#   source_dir  = "${path.module}/lambdas/my_lambda/"
#   output_path = "${path.module}/files/my_lambda.zip"
#   type        = "zip"
# }

resource "aws_lambda_function" "this" {
  count = var.create_function ? 1 : 0

  function_name = var.function_name
  description   = var.description
  filename      = var.package_type != "Zip" ? null : "${var.local_existing_package}/sample.py.zip"
  role          = try(aws_iam_role.lambda.arn, var.lambda_role)
  timeout       = var.timeout
  memory_size   = var.memory_size
  layers        = try([aws_lambda_layer_version.this[0].arn], null)
  package_type  = var.package_type
  handler       = var.package_type != "Zip" ? null : var.handler
  runtime       = var.package_type != "Zip" ? null : var.runtime
  image_uri     = var.package_type != "Image" ? null : "${var.image_uri}:latest"


  # image_uri     = var.package_type != "Image" ? null : coalesce(var.ecr_repo, var.default_repo)

  /* ephemeral_storage is not supported in gov-cloud region, so it should be set to `null` */
  dynamic "ephemeral_storage" {
    for_each = var.ephemeral_storage_size == null ? [] : [true]

    content {
      size = var.ephemeral_storage_size
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_target_arn == null ? [] : [true]
    content {
      target_arn = var.dead_letter_target_arn
    }
  }

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? [true] : []
    content {
      security_group_ids = var.vpc_security_group_ids
      subnet_ids         = var.vpc_subnet_ids
    }
  }

  tags = var.tags
}
