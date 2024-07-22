variable "codestarconnection_name" {
  description = "The name of Codestar connection"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of key-value resource tags to associate with the resource"
  type        = map(string)
  default     = {}
}
