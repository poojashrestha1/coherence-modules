output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnets_ids" {
  description = "List of cidr_blocks of public subnets"
  value       = compact(aws_subnet.public[*].id)
}

output "private_subnets_ids" {
  description = "List of cidr_blocks of private subnets"
  value       = compact(aws_subnet.private[*].id)
}

output "eip_id" {
  description = "The ID of the EIP"
  value       = aws_eip.this.id
}
