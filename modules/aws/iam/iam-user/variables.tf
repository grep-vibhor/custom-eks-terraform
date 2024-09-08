variable "user_name" {
  description = "The user's name. The name must consist of upper and lowercase alphanumeric characters with no spaces. You can also include any of the following characters: =,.@-_.. User names are not distinguished by case. For example, you cannot create users named both 'TESTUSER' and 'testuser'."
  type        = string
}

variable "environment" {
  type        = string
  default     = ""
  description = "Development environment to be added as a tag"
}

variable "tags" {
  type        = map(any)
  description = "(Optional) Key-value map of tags for the IAM user. "
  default     = {}
}

variable "path" {
  type        = string
  description = "(Optional, default '/') Path in which to create the user."
  default     = "/"
}

variable "permissions_boundary" {
  type        = string
  description = "(Optional) The ARN of the policy that is used to set the permissions boundary for the user."
  default     = null
}

variable "force_destroy" {
  type        = bool
  description = "(Optional, default false) When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed."
  default     = false
}

variable "policy" {
  default     = {}
  description = "The policy document should be use to create and associate to user"
  sensitive   = true
}

variable "managed_policy_arns" {
  type        = list(string)
  description = "(Optional, default []) list of AWS managed/UserManaged Policies attach it to user."
  default     = []
}