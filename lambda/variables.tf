##################
# Lambda Function
##################

variable "create_function" {
  description = "Controls whether Lambda function should be created"
  type        = bool
  default     = true
}

variable "function_name" {
  description = "Unique name for Lambda function"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of what your Lambda function does"
  type        = string
  default     = ""
}

variable "lambda_role" {
  description = "ARN of functions's execution role"
  type        = string
  default     = ""
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = number
  default     = 128
}

variable "local_existing_package" {
  description = "The absolute path to an existing zip-file to use"
  type        = string
  default     = null
}

variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function"
  type        = list(string)
  default     = null
}

variable "package_type" {
  description = "Lambda deployment package type. Valid values are Zip and Image"
  type        = string
  default     = null
}

variable "handler" {
  description = "Function entrypoint in your codelue"
  type        = string
  default     = ""
}

variable "runtime" {
  description = "Identifier of the function's runtime"
  type        = string
  default     = ""
}

variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  default     = {}
}

variable "vpc_subnet_ids" {
  description = "List of subnet ids when Lambda Function should run in the VPC. Usually private or intra subnets."
  type        = list(string)
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of security group ids when Lambda Function should run in the VPC."
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the object"
  type        = map(any)
  default     = {}
}

variable "ephemeral_storage_size" {
  description = "Amount of ephemeral storage (/tmp) in MB your Lambda Function can use at runtime. Valid value between 512 MB to 10,240 MB (10 GB)."
  type        = number
  default     = 512
}

variable "dead_letter_target_arn" {
  description = "The ARN of an SNS topic or SQS queue to notify when an invocation fails."
  type        = string
  default     = null
}

variable "image_uri" {
  description = "The ECR image URI containing the function's deployment package."
  type        = string
  default     = null
}

variable "default_repo" {
  description = "Default repository for Lambda_ECR"
  default     = null
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}

###############
# Lambda Layer
###############

variable "create_layer" {
  description = "Controls whether Lambda Layer resource should be created"
  type        = bool
  default     = false
}

variable "layer_name" {
  description = "Unique name for your Lambda Layer"
  type        = string
  default     = ""
}

variable "skip_destroy" {
  description = "Whether to retain the old version of a previously deployed Lambda Layer"
  type        = bool
  default     = false
}

variable "architectures" {
  description = "List of Architectures Lambda layer is compatible with"
  type        = list(string)
  default     = null
}

variable "compatible_runtimes" {
  description = "A list of Runtimes this layer is compatible with. Up to 5 runtimes can be specified."
  type        = list(string)
  default     = []
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

variable "allowed_triggers" {
  description = "Map of allowed triggers to create Lambda permissions"
  type        = map(any)
  default     = {}
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
  description = "Path of policies to that should be added to IAM role for Lambda Function"
  type        = string
  default     = null
}

variable "policy_statements" {
  description = "Map of dynamic policy statements to attach to Lambda Function role"
  type        = any
  default     = {}
}

###############
# S3 Artifacts
###############

variable "s3_bucket" {
  description = "S3 bucket to store artifacts"
  type        = string
  default     = null
}

variable "s3_key" {
  description = "S3 key of an object containing the function's deployment package"
  type        = string
  default     = null
}

############################################
# Lambda Event Source Mapping
############################################

variable "event_source_mapping" {
  description = "Map of event source mapping"
  type        = any
  default     = {}
}

variable "function_event_invoke_config" {
  description = "Manages an asynchronous invocation configuration for a Lambda Function or Alias"
  default     = {}
}
