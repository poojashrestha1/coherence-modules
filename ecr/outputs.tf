output "ecr_repository_arn" {
  description = "ARN of ECR repository"
  value       = aws_ecr_repository.this.arn
}

output "ecr_repository_url" {
  description = "URL of ECR repository"
  value       = try(aws_ecr_repository.this.repository_url, null)
}
