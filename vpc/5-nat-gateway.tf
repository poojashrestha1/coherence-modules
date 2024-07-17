locals {
  nat_gateway_ips = try(aws_eip.this[*].id, [])
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = element(local.nat_gateway_ips, 0)

  subnet_id = element(aws_subnet.public[*].id, 0)

  tags = merge(
    {
      "Name" = format("${var.vpc_name}-%s-ngw", element(var.azs, 0))
    },
    var.tags
  )

  depends_on = [aws_internet_gateway.this]

}

# resource "aws_route" "private_nat_gateway" {
#   count = var.enable_nat_gateway ? 1 : 0

#   route_table_id         = element(aws_route_table.private[*].id, count.index)
#   destination_cidr_block = var.nat_gateway_destination_cidr_block
#   nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

#   timeouts {
#     create = "5m"
#   }
# }
