resource "aws_s3_object" "this" {
  count = var.create_bucket && length(keys(var.object)) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  key    = "${var.object.parent_folder}/${var.object.key}"
  source = var.object.source

  tags = var.tags
}
