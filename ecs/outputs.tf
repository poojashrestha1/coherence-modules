output "ecs_cluster_name" {
  description = "Name of ECS Cluster"
  value       = aws_ecs_cluster.this.name
}

output "ecs_service_name" {
  description = "Name of ECS Service"
  value       = aws_ecs_service.this.name
}
