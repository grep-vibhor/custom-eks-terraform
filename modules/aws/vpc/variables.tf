variable "region" {
  type        = string
  description = "AWS region"

  validation {
    condition     = length(var.region) > 0
    error_message = "Empty region."
  }
}

variable "role_name" {
  type        = string
  default     = "terraform-management"
  description = "Role name to assume"
}



variable "vpc_name" {
  type        = string
  description = "VPC name"

  validation {
    condition     = length(var.vpc_name) > 0
    error_message = "Empty VPC name."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR."
}

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
}

variable "gateway_subnet_cidr_blocks" {
  description = "Available cidr blocks for gateway subnets."
  type        = list(string)
}

variable "enable_pod_subrange" {
  type        = bool
  default     = false
  description = "Enable dedicated pod subrange"
}

variable "pod_subrange" {
  type        = string
  default     = "100.64.0.0/16"
  description = "Pod subrange"
}

variable "flow_log_retention_in_days" {
  type        = number
  default     = 14
  description = "Specifies the number of days you want to retain log events in the specified log group for VPC flow logs."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to resources"
}

variable "global_tags" {
  type        = map(string)
  default     = {}
  description = "Global module tags"
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "pod_subnet_tags" {
  description = "Additional tags for the pod subnets"
  type        = map(string)
  default     = {}
}

variable "default_security_group_ingress" {
  type    = list(map(string))
  default = []
}

variable "default_security_group_egress" {
  type    = list(map(string))
  default = []
}

variable "single_nat_gateway" {
  default = false
}

variable "enable_vpc_flow_log" {
  description = "Whether or not to enable VPC Flow Logs"
  type        = bool
  default     = false
}

variable "flow_log_cloudwatch_log_group_kms_key_name" {
  description = "The Name of the KMS Key to use when encrypting log data for VPC flow logs."
  type        = string
  default     = null
}


variable "zones" {
  default = null
  description = "AZs for vpc"
  type = list(string)
}