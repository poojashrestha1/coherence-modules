resource "aws_lambda_layer_version" "this" {
  count = var.create_layer ? 1 : 0

  layer_name  = var.layer_name
  description = var.description

  compatible_architectures = var.architectures
  compatible_runtimes      = length(var.compatible_runtimes) > 0 ? var.compatible_runtimes : (var.runtime == "" ? null : [var.runtime])
  skip_destroy             = var.skip_destroy

  # s3_bucket = var.s3_bucket
  # s3_key    = var.s3_key
}
