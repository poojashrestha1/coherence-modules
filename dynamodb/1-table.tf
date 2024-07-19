resource "aws_dynamodb_table" "this" {
  name                        = var.name
  billing_mode                = var.billing_mode
  hash_key                    = var.hash_key
  range_key                   = var.range_key
  read_capacity               = var.read_capacity
  write_capacity              = var.write_capacity
  stream_enabled              = var.stream_enabled
  stream_view_type            = var.stream_view_type
  table_class                 = var.table_class
  deletion_protection_enabled = var.deletion_protection_enabled

  ttl {
    enabled        = var.ttl_enabled
    attribute_name = var.ttl_attribute_name
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  dynamic "attribute" {
    for_each = var.attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
    iterator = i

    content {
      name               = i.value.name
      range_key          = i.value.range_key
      projection_type    = i.value.projection_type
      non_key_attributes = try(i.value.non_key_attributes, null)
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    iterator = i

    content {
      hash_key           = i.value.hash_key
      name               = i.value.name
      projection_type    = i.value.projection_type
      non_key_attributes = try(i.value.non_key_attributes, null)
      range_key          = try(i.value.range_key, null)
      read_capacity      = try(i.value.read_capacity, null)
      write_capacity     = try(i.value.write_capacity, null)
    }
  }

  dynamic "replica" {
    for_each = var.replica_regions

    content {
      region_name            = replica.value.region_name
      kms_key_arn            = try(replica.value.kms_key_arn, null)
      point_in_time_recovery = try(replica.value.point_in_time_recovery, null)
      propagate_tags         = try(replica.value.propagate_tags, null)
    }
  }

  server_side_encryption {
    enabled     = var.server_side_encryption_enabled
    kms_key_arn = var.server_side_encryption_kms_key_arn
  }

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  tags = var.tags
}
