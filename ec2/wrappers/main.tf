module "wrapper" {
  source = "../"

  for_each = var.items

  ami                                  = try(each.value.ami, var.defaults.ami, null)
  associate_public_ip_address          = try(each.value.associate_public_ip_address, var.defaults.associate_public_ip_address, null)
  availability_zone                    = try(each.value.availability_zone, var.defaults.availability_zone, null)
  create_instance                      = try(each.value.create_instance, var.defaults.create_instance, true)
  get_password_data                    = try(each.value.get_password_data, var.defaults.get_password_data, null)
  ignore_ami_changes                   = try(each.value.ignore_ami_changes, var.defaults.ignore_ami_changes, false)
  instance_initiated_shutdown_behavior = try(each.value.instance_initiated_shutdown_behavior, var.defaults.instance_initiated_shutdown_behavior, null)
  instance_tags                        = try(each.value.instance_tags, var.defaults.instance_tags, {})
  instance_type                        = try(each.value.instance_type, var.defaults.instance_type, "t3.micro")
  key_name                             = try(each.value.key_name, var.defaults.key_name, null)
  launch_template                      = try(each.value.launch_template, var.defaults.launch_template, {})
  name                                 = try(each.value.name, var.defaults.name, "")
  network_interface                    = try(each.value.network_interface, var.defaults.network_interface, [])
  private_ip                           = try(each.value.private_ip, var.defaults.private_ip, null)
  root_block_device                    = try(each.value.root_block_device, var.defaults.root_block_device, [])
  subnet_id                            = try(each.value.subnet_id, var.defaults.subnet_id, null)
  tags                                 = try(each.value.tags, var.defaults.tags, {})
  user_data                            = try(each.value.user_data, var.defaults.user_data, null)
  user_data_base64                     = try(each.value.user_data_base64, var.defaults.user_data_base64, null)
  user_data_replace_on_change          = try(each.value.user_data_replace_on_change, var.defaults.user_data_replace_on_change, null)
  volume_tags                          = try(each.value.volume_tags, var.defaults.volume_tags, {})
  vpc_security_group_ids               = try(each.value.vpc_security_group_ids, var.defaults.vpc_security_group_ids, null)
  public_key                           = try(each.value.public_key, var.defaults.public_key, null)
  vpc_id                               = try(each.value.vpc_id, var.defaults.vpc_id, null)
}
