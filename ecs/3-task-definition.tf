# # module "container_definition" {
# #   source = "./modules/container-definition"

# #   for_each = var.container_definitions

# #   # Container Definition
# #   command                  = try(each.value.command, var.container_definition_defaults.command, [])
# #   cpu                      = try(each.value.cpu, var.container_definition_defaults.cpu, null)
# #   dependencies             = try(each.value.dependencies, var.container_definition_defaults.dependencies, [])
# #   disable_networking       = try(each.value.disable_networking, var.container_definition_defaults.disable_networking, null)
# #   dns_search_domains       = try(each.value.dns_search_domains, var.container_definition_defaults.dns_search_domains, [])
# #   dns_servers              = try(each.value.dns_servers, var.container_definition_defaults.dns_servers, [])
# #   docker_labels            = try(each.value.docker_labels, var.container_definition_defaults.docker_labels, {})
# #   docker_security_options  = try(each.value.docker_security_options, var.container_definition_defaults.docker_security_options, [])
# #   entrypoint               = try(each.value.entrypoint, var.container_definition_defaults.entrypoint, [])
# #   environment              = try(each.value.environment, var.container_definition_defaults.environment, [])
# #   environment_files        = try(each.value.environment_files, var.container_definition_defaults.environment_files, [])
# #   essential                = try(each.value.essential, var.container_definition_defaults.essential, null)
# #   extra_hosts              = try(each.value.extra_hosts, var.container_definition_defaults.extra_hosts, [])
# #   firelens_configuration   = try(each.value.firelens_configuration, var.container_definition_defaults.firelens_configuration, {})
# #   health_check             = try(each.value.health_check, var.container_definition_defaults.health_check, {})
# #   hostname                 = try(each.value.hostname, var.container_definition_defaults.hostname, null)
# #   image                    = try(each.value.image, var.container_definition_defaults.image, null)
# #   interactive              = try(each.value.interactive, var.container_definition_defaults.interactive, false)
# #   links                    = try(each.value.links, var.container_definition_defaults.links, [])
# #   linux_parameters         = try(each.value.linux_parameters, var.container_definition_defaults.linux_parameters, {})
# #   log_configuration        = try(each.value.log_configuration, var.container_definition_defaults.log_configuration, {})
# #   memory                   = try(each.value.memory, var.container_definition_defaults.memory, null)
# #   memory_reservation       = try(each.value.memory_reservation, var.container_definition_defaults.memory_reservation, null)
# #   mount_points             = try(each.value.mount_points, var.container_definition_defaults.mount_points, [])
# #   name                     = try(each.value.name, each.key)
# #   port_mappings            = try(each.value.port_mappings, var.container_definition_defaults.port_mappings, [])
# #   privileged               = try(each.value.privileged, var.container_definition_defaults.privileged, false)
# #   pseudo_terminal          = try(each.value.pseudo_terminal, var.container_definition_defaults.pseudo_terminal, false)
# #   readonly_root_filesystem = try(each.value.readonly_root_filesystem, var.container_definition_defaults.readonly_root_filesystem, true)
# #   repository_credentials   = try(each.value.repository_credentials, var.container_definition_defaults.repository_credentials, {})
# #   resource_requirements    = try(each.value.resource_requirements, var.container_definition_defaults.resource_requirements, [])
# #   secrets                  = try(each.value.secrets, var.container_definition_defaults.secrets, [])
# #   start_timeout            = try(each.value.start_timeout, var.container_definition_defaults.start_timeout, 30)
# #   stop_timeout             = try(each.value.stop_timeout, var.container_definition_defaults.stop_timeout, 120)
# #   system_controls          = try(each.value.system_controls, var.container_definition_defaults.system_controls, [])
# #   ulimits                  = try(each.value.ulimits, var.container_definition_defaults.ulimits, [])
# #   user                     = try(each.value.user, var.container_definition_defaults.user, 0)
# #   volumes_from             = try(each.value.volumes_from, var.container_definition_defaults.volumes_from, [])
# #   working_directory        = try(each.value.working_directory, var.container_definition_defaults.working_directory, null)
# # }

# resource "aws_ecs_task_definition" "this" {
#   count = var.create_task_definition ? 1 : 0

#   family = var.family

#   # container_definitions = jsonencode([for k, v in module.container_definition : v.container_definition])
#   container_definitions = file(var.container_definitions)

#   cpu          = var.cpu
#   memory       = var.memory
#   network_mode = var.network_mode
#   pid_mode     = var.pid_mode

#   requires_compatibilities = var.requires_compatibilities

#   execution_role_arn = try(aws_iam_role.task_exec[0].arn, var.task_exec_iam_role_arn)
#   task_role_arn      = try(aws_iam_role.tasks[0].arn, var.tasks_iam_role_arn)

#   dynamic "runtime_platform" {
#     for_each = length(var.runtime_platform) > 0 ? [var.runtime_platform] : []

#     content {
#       cpu_architecture        = try(runtime_platform.value.cpu_architecture, null)
#       operating_system_family = try(runtime_platform.value.operating_system_family, null)
#     }
#   }

#   dynamic "placement_constraints" {
#     for_each = var.task_definition_placement_constraints

#     content {
#       expression = try(placement_constraints.value.expression, null)
#       type       = placement_constraints.value.type
#     }
#   }

#   dynamic "volume" {
#     for_each = var.volume

#     content {
#       dynamic "docker_volume_configuration" {
#         for_each = try([volume.value.docker_volume_configuration], [])
#         iterator = i

#         content {
#           autoprovision = try(i.value.autoprovision, null)
#           driver_opts   = try(i.value.driver_opts, null)
#           driver        = try(i.value.driver, null)
#           labels        = try(i.value.driver, null)
#           scope         = try(i.value.scope, null)
#         }
#       }

#       # dynamic "efs_volume_configuration" {
#       #   for_each = try([volume.each.efs_volume_configuration], [])
#       #   iterator = i

#       #   content {
#       #     dynamic "authorization_config" {
#       #       for_each = try([i.value.authorization_config], [])

#       #       content {
#       #         access_point_id = try(authorization_config.value.access_point_id, null)
#       #         iam             = try(authorization_config.value.iam, null)
#       #       }
#       #     }

#       #     file_system_id          = i.value.file_system_id
#       #     root_directory          = i.value.root_directory
#       #     transit_encryption      = i.value.transit_encryption
#       #     transit_encryption_port = i.value.transit_encryption_port
#       #   }
#       # }

#       # dynamic "fsx_windows_file_server_volume_configuration" {
#       #   for_each = try([volume.each.fsx_windows_file_server_volume_configuration], [])
#       #   iterator = i

#       #   content {
#       #     dynamic "authorization_config" {
#       #       for_each = try([i.value.authorization_config], [])

#       #       content {
#       #         credentials_parameter = authorization_config.value.credentials_parameter
#       #         domain                = authorization_config.value.domain
#       #       }
#       #     }

#       #     file_system_id = i.value.file_system_id
#       #     root_directory = i.value.root_directory
#       #   }
#       # }

#       host_path = try(volume.value.host_path, null)
#       name      = try(volume.value.name, volume.key)
#     }
#   }

#   tags = merge(var.tags, var.task_tags)
# }
