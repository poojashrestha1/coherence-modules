resource "aws_ecr_lifecycle_policy" "this" {
  count = var.create_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.this.name
  policy     = jsonencode(var.lifecycle_policy)
}
