variable "project_name" {
  description = "Project's name"
  type        = string
  default     = null
}

variable "description" {
  description = "Short description of the project"
  type        = string
  default     = null
}

variable "provider_source" {
  description = "Provider source configuration"
  type        = map(any)
  default     = {}
}

variable "build_timeout" {
  description = "How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed.The default is 60 minutes."
  type        = number
  default     = 60
}

variable "buildspec" {
  type        = string
  default     = ""
  description = "Optional buildspec declaration to use for building the project"
}

variable "environment" {
  description = "Environment of the Codebuild"
  type        = any
  default     = {}
}

variable "artifacts" {
  description = "Configuration artifacts"
  type        = map(any)
  default     = {}
}

variable "cache" {
  description = "Cache configuration"
  type        = any
  default     = {}
}

variable "cloudwatch_logs" {
  description = "Cloudwatch log configuration"
  type        = map(string)
  default     = {}
}


######
# IAM
######

variable "role_name" {
  description = "Name of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path of IAM role to use for Lambda Function"
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
  description = "Path of policies to that should be added to IAM role for CodeBuild"
  type        = string
  default     = null
}

variable "policy_statements" {
  description = "Map of dynamic policy statements to attach to CodeBuild role"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Map of key-value resource tags to associate with the resource"
  type        = map(string)
  default     = {}
}
