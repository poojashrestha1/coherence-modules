module "wrapper" {
  source = "../"

  for_each = var.items

  repository_name          = try(each.value.repository_name, var.defaults.repository_name, "")
  image_tag_mutability     = try(each.value.image_tag_mutability, var.defaults.image_tag_mutability, "MUTABLE")
  encryption_type          = try(each.value.encryption_type, var.defaults.encryption_type, "AES256")
  kms_key                  = try(each.value.kms_key, var.defaults.kms_key, null)
  scan_on_push             = try(each.value.scan_on_push, var.defaults.scan_on_push, true)
  lambda_read_access_arns  = try(each.value.lambda_read_access_arns, var.defaults.lambda_read_access_arns, [])
  attach_repository_policy = try(each.value.attach_repository_policy, var.defaults.attach_repository_policy, false)
  create_lifecycle_policy  = try(each.value.create_lifecycle_policy, var.defaults.create_lifecycle_policy, true)
  lifecycle_policy         = try(each.value.lifecycle_policy, var.defaults.lifecycle_policy, {})
  tags                     = try(each.value.tags, var.defaults.tags, {})
}
