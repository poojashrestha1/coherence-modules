locals {
  create_security_group = var.create_security_group && var.network_mode == "awsvpc"
  security_group_name   = try(coalesce(var.security_group_name, var.service_name), "")
}

resource "aws_security_group" "this" {
  count = local.create_security_group ? 1 : 0

  name        = local.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      "Name" = local.security_group_name
    },
    var.security_group_tags,
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "this" {
  for_each = { for k, v in var.security_group_rules : k => v if local.create_security_group }

  security_group_id = aws_security_group.this[0].id
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = each.value.type

  cidr_blocks              = try(each.value.cidr_blocks.null)
  description              = try(each.value.description, null)
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, null)
  prefix_list_ids          = try(each.value.prefix_list_ids, null)
  self                     = try(each.value.self, null)
  source_security_group_id = try(each.value.source_security_group_id, null)
}
