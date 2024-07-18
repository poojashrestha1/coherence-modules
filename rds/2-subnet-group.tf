# locals {
#   description = coalesce(var.subnet_group_description, format("%s subnet group", var.subnet_group_name))
# }

# resource "aws_db_subnet_group" "this" {
#   count = var.create_subnet_group ? 1 : 0

#   name        = var.subnet_group_name
#   description = local.description
#   subnet_ids  = data.aws_subnet_ids.selected.ids

#   tags = merge(
#     var.tags,
#     {
#       "Name" = var.subnet_group_name
#     },
#   )
# }
