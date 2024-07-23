variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

##########
# Cluster
##########

variable "cluster_name" {
  description = "Name of the cluster (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string
  default     = ""
}

variable "cluster_configuration" {
  description = "The execute command configuration for the cluster."
  type        = any
  default     = {}
}

variable "cluster_settings" {
  description = "Configuration block(s) with cluster settings. For example, this can be used to enable CloudWatch Container Insights for a cluster"
  type        = any
  default     = []
}

######################
# ECS Task Definition
######################

variable "create_task_definition" {
  description = "Determines whether to create a task definition or use existing/provided"
  type        = bool
  default     = true
}

variable "family" {
  description = "A unique name for your task definition"
  type        = string
  default     = null
}

variable "container_definitions" {
  description = "A map of valid [container definitions](http://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html). Please note that you should only provide values that are part of the container definition document"
  type        = any
  default     = {}
}

variable "cpu" {
  description = "Number of cpu units used by the task. If the `requires_compatibilities` is `FARGATE` this field is required"
  type        = number
  default     = 1024
}

variable "memory" {
  description = "Amount (in MiB) of memory used by the task. If the `requires_compatibilities` is `FARGATE` this field is required"
  type        = number
  default     = 2048
}

variable "network_mode" {
  description = "Docker networking mode to use for the containers in the task. Valid values are `none`, `bridge`, `awsvpc`, and `host`"
  type        = string
  default     = "awsvpc"
}

variable "pid_mode" {
  description = "Process namespace to use for the containers in the task. The valid values are `host` and `task`"
  type        = string
  default     = null
}

variable "task_definition_placement_constraints" {
  description = "Configuration block for rules that are taken into consideration during task placement (up to max of 10). This is set at the task definition, see `placement_constraints` for setting at the service"
  type        = any
  default     = {}
}

variable "requires_compatibilities" {
  description = "Set of launch types required by the task. The valid values are `EC2` and `FARGATE`"
  type        = list(string)
  default     = ["EC2"]
}

variable "runtime_platform" {
  description = "Configuration block for `runtime_platform` that containers in your task may use"
  type        = any
  default = {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

variable "volume" {
  description = "Configuration block for volumes that containers in your task may use"
  type        = any
  default     = {}
}

variable "task_tags" {
  description = "A map of additional tags to add to the task definition/set created"
  type        = map(string)
  default     = {}
}

##########
# Service
##########

variable "service_name" {
  description = "Name of the service (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string
  default     = null
}

variable "alarms" {
  description = "Information about the CloudWatch alarms"
  type        = any
  default     = {}
}

variable "capacity_provider_strategy" {
  description = "Capacity provider strategies to use for the service. Can be one or more"
  type        = any
  default     = {}
}

variable "launch_type" {
  description = "Launch type on which to run your service. The valid values are EC2, FARGATE, and EXTERNAL"
  type        = string
  default     = "EC2"
}

variable "deployment_circuit_breaker" {
  description = "Configuration block for deployment circuit breaker"
  type        = any
  default     = {}
}

variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running"
  type        = number
  default     = 1
}

variable "scheduling_strategy" {
  description = "Scheduling strategy to use for the service. The valid values are `REPLICA` and `DAEMON`. Defaults to `REPLICA`"
  type        = string
  default     = null
}

variable "propagate_tags" {
  description = "Specifies whether to propagate the tags from the task definition or the service to the tasks"
  type        = string
  default     = "SERVICE"
}

variable "deployment_controller" {
  description = "Configuration block for deployment controller configuration"
  type        = any
  default     = {}
}

variable "ordered_placement_strategy" {
  description = "Service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence"
  type        = any
  default     = {}
}

variable "load_balancer" {
  description = "Configuration block for load balancers"
  type        = any
  default     = {}
}

variable "deployment_maximum_percent" {
  description = "Upper limit (as a percentage of the service's `desired_count`) of the number of running tasks that can be running in a service during a deployment"
  type        = number
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "Lower limit (as a percentage of the service's `desired_count`) of the number of running tasks that must remain running and healthy in a service during a deployment"
  type        = number
  default     = 66
}

#####################
# Service - IAM Role
#####################

variable "create_iam_role" {
  description = "Determines whether the ECS service IAM role should be created"
  type        = bool
  default     = true
}

variable "iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = null
}

variable "iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}

variable "iam_role_tags" {
  description = "A map of additional tags to add to the IAM role created"
  type        = map(string)
  default     = {}
}

variable "iam_role_statements" {
  description = "A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage"
  type        = any
  default     = {}
}

############################
# Task Execution - IAM Role
############################

variable "create_task_exec_iam_role" {
  description = "Determines whether the ECS task definition IAM role should be created"
  type        = bool
  default     = true
}

variable "task_exec_iam_role_arn" {
  description = "Existing IAM role ARN"
  type        = string
  default     = null
}

variable "task_exec_iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = null
}

variable "task_exec_iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}

variable "task_exec_iam_role_tags" {
  description = "A map of additional tags to add to the IAM role created"
  type        = map(string)
  default     = {}
}

variable "create_task_exec_policy" {
  description = "Determines whether the ECS task definition IAM policy should be created. This includes permissions included in AmazonECSTaskExecutionRolePolicy as well as access to secrets and SSM parameters"
  type        = bool
  default     = true
}

variable "task_exec_ssm_param_arns" {
  description = "List of SSM parameter ARNs the task execution role will be permitted to get/read"
  type        = list(string)
  default     = ["arn:aws:ssm:*:*:parameter/*"]
}

variable "task_exec_secret_arns" {
  description = "List of SecretsManager secret ARNs the task execution role will be permitted to get/read"
  type        = list(string)
  default     = ["arn:aws:secretsmanager:*:*:secret:*"]
}

variable "task_exec_iam_statements" {
  description = "A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage"
  type        = any
  default     = {}
}

##################
# Task - IAM Role
##################

variable "create_tasks_iam_role" {
  description = "Determines whether the ECS tasks IAM role should be created"
  type        = bool
  default     = true
}

variable "tasks_iam_role_arn" {
  description = "Existing IAM role ARN"
  type        = string
  default     = null
}

variable "tasks_iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = null
}

variable "tasks_iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}

variable "tasks_iam_role_tags" {
  description = "A map of additional tags to add to the IAM role created"
  type        = map(string)
  default     = {}
}

##################
# Cloudwatch Logs
##################

variable "create_cloudwatch_log_group" {
  description = "Determines whether a log group is created by this module for the cluster logs. If not, AWS will automatically create one if logging is enabled"
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain log events"
  type        = number
  default     = 90
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "If a KMS Key ARN is set, this key will be used to encrypt the corresponding log group. Please be sure that the KMS Key has an appropriate key policy (https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html)"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_tags" {
  description = "A map of additional tags to add to the log group created"
  type        = map(string)
  default     = {}
}

#####################
# Capacity Providers
#####################

variable "autoscaling_capacity_providers" {
  description = "Map of autoscaling capacity provider definitions to create for the cluster"
  type        = any
  default     = {}
}


###################
# Security Groups
###################

variable "create_security_group" {
  description = "Determines if a secuirty group is created"
  type        = bool
  default     = true
}

variable "security_group_name" {
  description = "Name to use on security group created"
  type        = string
  default     = null
}

variable "security_group_description" {
  description = "Description of the security group created"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "ID of VPC in which to create security group"
  type        = string
  default     = null
}

variable "security_group_rules" {
  description = "Security group rules to add to the security group created"
  type        = map(any)
  default     = {}
}

variable "security_group_tags" {
  description = "A map of additional security tags to add to the security group created"
  type        = map(string)
  default     = {}
}
