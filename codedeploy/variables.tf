#########################
# CodeDeploy Application
#########################

variable "application_name" {
  description = "The name of the application"
  type        = string
  default     = null
}

variable "compute_platform" {
  description = "The compute platform can either be ECS, Lambda, or Server"
  type        = string
  default     = null
}

##############################
# CodeDeploy Deployment Group
##############################

variable "deployment_group_name" {
  description = "The name of the deployment group"
  type        = string
  default     = null
}

variable "service_role_arn" {
  description = "The service role ARN that allows deployments"
  type        = string
  default     = null
}

variable "deployment_group_tags" {
  description = "Tags for deployment groups"
  type        = map(string)
  default     = {}
}

variable "enable_rollback" {
  description = "Indicates whether a defined automatic rollback configuration is currently enabled for this Deployment Group"
  type        = bool
  default     = null
}

variable "rollback_events" {
  description = "The event type or types that trigger a rollback"
  type        = list(string)
  default     = []
}

variable "ecs_service" {
  description = "Configuration block(s) of the ECS services for a deployment group"
  type        = map(string)
  default     = {}
}

variable "lb_listener_arns" {
  description = "List of Amazon Resource Names (ARNs) of the load balancer listeners"
  type        = list(string)
  default     = []
}

variable "lb_tg" {
  description = "List of target groups associated with load balancer"
  type        = list(map(string))
  default     = []
}

variable "deployment_option" {
  description = "Indicates whether to route deployment traffic behind a load balancer"
  type        = string
  default     = null
}

variable "deployment_type" {
  description = "Indicates whether to run an in-place deployment or a blue/green deployment"
  type        = string
  default     = null
}

variable "termination_wait_time_in_minutes" {
  description = "The number of minutes to wait after a successful blue/green deployment before terminating instances from the original environment"
  type        = number
  default     = null
}

######
# IAM
######

variable "role_name" {
  description = "Name of IAM role to use for CodePipeline"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path of IAM role to use for CodePipeline"
  type        = string
  default     = null
}

###########
# Policies
###########

variable "policy_name" {
  description = "IAM policy name. It override the default value, which is the same as role_name"
  type        = string
  default     = null
}

variable "policy_path" {
  description = "Path of policies to that should be added to IAM role for CodePipeline"
  type        = string
  default     = null
}

variable "policy_statements" {
  description = "Map of dynamic policy statements to attach to CodePipeline role"
  type        = any
  default     = {}
}

################
# General Block
################

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}
