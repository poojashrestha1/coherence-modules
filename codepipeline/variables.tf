variable "pipeline_name" {
  description = "The name of the pipeline"
  type        = string
  default     = null
}

variable "pipeline_type" {
  description = "Type of the pipeline. Possible values are: V1 and V2"
  type        = string
  default     = null
}

variable "codestarconnection_arn" {
  description = "The ARN of Codestar connection"
  type        = string
  default     = null
}

variable "execution_mode" {
  description = "The method that the pipeline will use to handle multiple executions"
  type        = string
  default     = null
}

variable "codepipeline_bucket" {
  description = "Bucket to store codepipeline artifacts"
  type        = string
  default     = null
}

variable "build_config" {
  description = "Configuration for CodePipeline build"
  type        = map(string)
  default     = {}
}

variable "stages" {
  description = "Extra stages in Codepipeline except Source and Build"
  type        = any
  default     = []
}

variable "trigger" {
  description = "A trigger block. Valid only when `pipeline_type` is `V2`"
  type        = list(any)
  default     = []
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

variable "codebuild_project_arn" {
  description = "CodeBuild ARN for policy resource"
  type        = string
  default     = null
}

variable "policy_statements" {
  description = "Map of dynamic policy statements to attach to CodePipeline role"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Map of key-value resource tags to associate with the resource"
  type        = map(string)
  default     = {}
}
