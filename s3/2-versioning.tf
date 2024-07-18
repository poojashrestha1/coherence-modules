resource "aws_s3_bucket_versioning" "this" {
  count = var.create_bucket && length(keys(var.versioning)) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  versioning_configuration {
    status     = var.versioning.status
    mfa_delete = var.versioning.mfa_delete
  }
}
