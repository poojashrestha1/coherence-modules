output "codedeploy_application_name" {
  description = "Name of CodeDeploy application"
  value       = aws_codedeploy_app.this.name
}

output "codedeploy_application_group" {
  description = "Name of CodeDeploy application group"
  value       = aws_codedeploy_deployment_group.this.app_name
}
