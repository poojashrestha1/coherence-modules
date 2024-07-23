data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = length(var.lambda_read_access_arns) > 0 ? [1] : []

    content {
      sid = "LambdaECRImageRetrievalPolicy"

      principals {
        identifiers = ["lambda.amazonaws.com"]
        type        = "Service"
      }

      actions = [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
      ]

      condition {
        test     = "StringLike"
        variable = "aws:sourceArn"

        values = var.lambda_read_access_arns
      }
    }
  }
}

resource "aws_ecr_repository_policy" "this" {
  count = var.attach_repository_policy ? 1 : 0

  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.this.json
}
