output "codestarconnection_arn" {
  description = "ARN of Codestar connection used"
  value       = data.aws_codestarconnections_connection.this.arn
}
