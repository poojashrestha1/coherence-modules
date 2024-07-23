variable "repository_name" {
  description = "Name of the repository"
  type        = string
  default     = ""
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
}

variable "encryption_type" {
  description = "The encryption type to use for the repository"
  type        = string
  default     = "AES256"
}

variable "kms_key" {
  description = "The ARN of the KMS key to use when `encryption_type` is `KMS`"
  type        = string
  default     = null
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "lambda_read_access_arns" {
  description = "The ARNs of the Lambda function that have read access to the repository"
  type        = list(string)
  default     = []
}

variable "attach_repository_policy" {
  description = "Determines whether a repository policy will be attached to the repository"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}


variable "create_lifecycle_policy" {
  description = "Determines whether a lifecycle policy will be created"
  type        = bool
  default     = true
}

variable "lifecycle_policy" {
  description = "The policy document"
  type        = map(any)
  default     = {}
}
