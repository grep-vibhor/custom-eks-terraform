variable "region" {
  type        = string
  description = "AWS region"

  validation {
    condition     = length(var.region) > 0
    error_message = "Empty region."
  }
}

variable "name" {
  description = "Name of the Role"
  type        = string
}

variable "assume_role_policy" {
  description = "Whether to create Iam role."
  sensitive   = true
}

variable "managed_policy_arns" {
  type        = list(any)
  default     = []
  description = "Set of exclusive IAM managed policy ARNs to attach to the IAM role"
}
variable "force_detach_policies" {
  type        = bool
  default     = false
  description = "The policy that grants an entity permission to assume the role."
}

variable "path" {
  type        = string
  default     = "/"
  description = "The path to the role."
}

variable "description" {
  type        = string
  default     = ""
  description = "The description of the role."
}

variable "max_session_duration" {
  type        = number
  default     = null
  description = "The maximum session duration (in seconds) that you want to set for the specified role. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 1 hour to 12 hours."
}

variable "permissions_boundary" {
  type        = string
  default     = ""
  description = "The ARN of the policy that is used to set the permissions boundary for the role."
  sensitive   = true
}

variable "policy" {
  default     = null
  description = "The policy document."
  sensitive   = true
}

variable "policy_enabled" {
  type        = bool
  default     = false
  description = "Whether to Attach Iam policy with role."
}

variable "policy_arn" {
  type        = string
  default     = ""
  description = "The ARN of the policy you want to apply."
  sensitive   = true
}

variable "policy_name" {
  description = "Name of the Policy to create"
  default     = ""
  type        = string
}

variable "inline_policy" {
  type        = list(any)
  default     = []
  description = "Configuration block defining an exclusive set of IAM inline policies associated with the IAM role. See below. If no blocks are configured, Terraform will not manage any inline policies in this resource. Configuring one empty block (i.e., inline_policy {}) will cause Terraform to remove all inline policies added out of band on apply."
}
variable "environment" {
  type        = string
  description = "A string representing the env to deploy in. Its value will be added as a tag here"
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Tags added to all zones. Will take precedence over tags from the 'zones' variable"
}