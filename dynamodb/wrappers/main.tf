module "wrapper" {
  source = "../"

  for_each = var.items

  name                               = try(each.value.name, var.defaults.name, null)
  billing_mode                       = try(each.value.billing_mode, var.defaults.billing_mode, "PAY_PER_REQUEST")
  hash_key                           = try(each.value.hash_key, var.defaults.hash_key, null)
  range_key                          = try(each.value.range_key, var.defaults.range_key, null)
  write_capacity                     = try(each.value.write_capacity, var.defaults.write_capacity, null)
  read_capacity                      = try(each.value.read_capacity, var.defaults.read_capacity, null)
  stream_enabled                     = try(each.value.stream_enabled, var.defaults.stream_enabled, false)
  stream_view_type                   = try(each.value.stream_view_type, var.defaults.stream_view_type, null)
  table_class                        = try(each.value.table_class, var.defaults.table_class, null)
  deletion_protection_enabled        = try(each.value.deletion_protection_enabled, var.defaults.deletion_protection_enabled, null)
  attributes                         = try(each.value.attributes, var.defaults.attributes, [])
  point_in_time_recovery_enabled     = try(each.value.point_in_time_recovery_enabled, var.defaults.point_in_time_recovery_enabled, false)
  global_secondary_indexes           = try(each.value.global_secondary_indexes, var.defaults.global_secondary_indexes, [])
  local_secondary_indexes            = try(each.value.local_secondary_indexes, var.defaults.local_secondary_indexes, [])
  ttl_enabled                        = try(each.value.ttl_enabled, var.defaults.ttl_enabled, false)
  ttl_attribute_name                 = try(each.value.ttl_attribute_name, var.defaults.ttl_attribute_name, "")
  replica_regions                    = try(each.value.replica_regions, var.defaults.replica_regions, [])
  server_side_encryption_enabled     = try(each.value.server_side_encryption_enabled, var.defaults.server_side_encryption_enabled, false)
  server_side_encryption_kms_key_arn = try(each.value.server_side_encryption_kms_key_arn, var.defaults.server_side_encryption_kms_key_arn, null)
  seed_file                          = try(each.value.seed_file, var.defaults.seed_file, null)
  timeouts = try(each.value.timeouts, var.defaults.timeouts, {
    create = "30m"
    update = "60m"
    delete = "10m"
  })
  tags = try(each.value.tags, var.defaults.tags, {})
}
