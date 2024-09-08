variable "account_id" {
  type        = string
  description = "AWS Account id"

  validation {
    condition     = length(var.account_id) > 0
    error_message = "Empty AWS account id."
  }
}

variable "role_name" {
  type        = string
  default     = "circleci-management"
  description = "Role name to assume"
}

variable "region" {
  type        = string
  description = "AWS region"

  validation {
    condition     = length(var.region) > 0
    error_message = "Empty region."
  }
}

variable "kms_master_key_name" {
  type        = string
  default     = "master"
  description = "KMS key name"

  validation {
    condition     = length(var.kms_master_key_name) > 0
    error_message = "Empty KMS name."
  }
}

##All though we are passing we are not using the following variable, retaining this var as it is not to distrub any flows.
variable "environment_type" {
  type        = string
  description = "Type of the environment"
}

variable "tags" {
  type  = map(string)
  description = "A map of tags(i.e key/value ) assigned to KMS key"
  default = {}
}