# locals {
#   description = coalesce(var.db_parameter_group_description, format("%s parameter group", var.db_parameter_group_name))
# }

# resource "aws_db_parameter_group" "this" {
#   count = var.create_db_parameter_group ? 1 : 0

#   name        = var.db_parameter_group_name
#   description = local.description
#   family      = var.family

#   dynamic "parameter" {
#     for_each = var.parameters
#     content {
#       name         = parameter.value.name
#       value        = parameter.value.value
#       apply_method = lookup(parameter.value, "apply_method", null)
#     }
#   }

#   tags = merge(
#     var.tags,
#     {
#       "Name" = var.db_parameter_group_name
#     },
#   )

#   lifecycle {
#     create_before_destroy = true
#   }
# }
