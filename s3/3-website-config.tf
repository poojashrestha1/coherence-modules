resource "aws_s3_bucket_website_configuration" "this" {
  count = var.create_bucket && length(keys(var.website)) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  dynamic "index_document" {
    for_each = try([var.website["index_document"]], [])

    content {
      suffix = index_document.value
    }
  }

  dynamic "error_document" {
    for_each = try([var.website["error_document"]], [])

    content {
      key = error_document.value
    }
  }
}
