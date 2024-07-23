locals {
  health_check = length(var.health_check) > 0 ? merge({
    interval = 30,
    retries  = 3,
    timeout  = 5
  }, var.health_check) : null

  definition = {
    command                = length(var.command) > 0 ? var.command : null
    cpu                    = var.cpu
    dependsOn              = length(var.dependencies) ? var.dependencies : null
    disableNetworking      = var.disable_networking
    dnsSearchDomains       = length(var.dns_search_domains) > 0 ? var.dns_search_domains : null
    dnsServers             = length(var.dns_servers) > 0 ? var.dns_servers : null
    dockerLabels           = length(var.docker_labels) > 0 ? var.docker_labels : null
    dockerSecurityOptions  = length(var.docker_security_options) > 0 ? var.docker_security_options : null
    entryPoint             = length(var.entrypoint) > 0 ? var.entrypoint : null
    environment            = var.environment
    environmentFiles       = length(var.environment_files) > 0 ? var.environment_files : null
    essential              = var.essential
    extraHosts             = length(var.extra_hosts) > 0 ? var.extra_hosts : 0
    firelensConfiguration  = length(var.firelens_configuration) > 0 ? var.firelens_configuration : null
    healthCheck            = local.health_check
    hostname               = var.hostname
    image                  = var.image
    interactive            = var.interactive
    links                  = length(var.links) ? var.links : 0
    linuxParameters        = var.linux_parameters
    logConfiguration       = length(var.log_configuration) > 0 ? var.log_configuration : null
    memory                 = var.memory
    memoryReservation      = var.memory_reservation
    mountPoints            = var.mount_points
    name                   = var.name
    portMappings           = length(var.port_mappings) ? var.port_mappings : 0
    privileged             = var.privileged
    pseudoTerminal         = var.pseudo_terminal
    readonlyRootFilesystem = var.readonly_root_filesystem
    repositoryCredentials  = length(var.repository_credentials) > 0 ? var.repository_credentials : null
    resourceRequirements   = length(var.resource_requirements) > 0 ? var.resource_requirements : null
    secrets                = length(var.secrets) > 0 ? var.secrets : null
    startTimeout           = var.start_timeout
    stopTimeout            = var.stop_timeout
    systemControls         = length(var.system_controls) > 0 ? var.system_controls : null
    ulimits                = length(var.ulimits) > 0 ? var.ulimits : null
    user                   = var.user
    volumesFrom            = var.volumes_from
    workingDirectory       = var.working_directory
  }

  # Strip out all null values, ECS API will provide defaults in place of null/empty values
  container_definition = { for k, v in local.definition : k => v if v != null }
}
