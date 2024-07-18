module "wrapper" {
  source = "../"

  for_each = var.items

  create_bucket           = try(each.value.create_bucket, var.defaults.create_bucket, true)
  bucket                  = try(each.value.bucket, var.defaults.bucket, null)
  bucket_prefix           = try(each.value.bucket_prefix, var.defaults.bucket_prefix, null)
  force_destroy           = try(each.value.force_destroy, var.defaults.force_destroy, false)
  object_lock_enabled     = try(each.value.object_lock_enabled, var.defaults.object_lock_enabled, false)
  versioning              = try(each.value.versioning, var.defaults.versioning, {})
  website                 = try(each.value.website, var.defaults.website, {})
  object                  = try(each.value.object, var.defaults.object, {})
  create_notification     = try(each.value.create_notification, var.defaults.create_notification, false)
  sqs_notifications       = try(each.value.sqs_notifications, var.defaults.sqs_notifications, {})
  create_sqs_policy       = try(each.value.create_sqs_policy, var.defaults.create_sqs_policy, false)
  queue_policy_statements = try(each.value.queue_policy_statements, var.defaults.queue_policy_statements, {})
  bucket_arn              = try(each.value.bucket_arn, var.defaults.bucket_arn, null)
  attach_public_policy    = try(each.value.attach_public_policy, var.defaults.attach_public_policy, true)
  block_public_acls       = try(each.value.block_public_acls, var.defaults.block_public_acls, true)
  block_public_policy     = try(each.value.block_public_policy, var.defaults.block_public_policy, true)
  ignore_public_acls      = try(each.value.ignore_public_acls, var.defaults.ignore_public_acls, true)
  restrict_public_buckets = try(each.value.restrict_public_buckets, var.defaults.restrict_public_buckets, true)
  attach_open_policy      = try(each.value.attach_open_policy, var.defaults.attach_open_policy, false)
  bucket_policy           = try(each.value.bucket_policy, var.defaults.bucket_policy, {})
  tags                    = try(each.value.tags, var.defaults.tags, {})
}
