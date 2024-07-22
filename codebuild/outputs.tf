output "codebuild_project_arn" {
  description = "ARN of CodeBuild Project"
  value       = aws_codebuild_project.this.arn
}

output "codebuild_project_name" {
  description = "Name of CodeBuild Output"
  value       = aws_codebuild_project.this.name
}
