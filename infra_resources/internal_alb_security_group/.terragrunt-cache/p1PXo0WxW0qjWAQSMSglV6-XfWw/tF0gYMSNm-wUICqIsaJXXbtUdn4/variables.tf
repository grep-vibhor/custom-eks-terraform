variable "region" {
  type        = string
  description = "AWS region"

  validation {
    condition     = length(var.region) > 0
    error_message = "Empty region."
  }
}
variable "sg_name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}
variable "tags" {
  default = {}
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "The ID of the VPC that the instance security group belongs to."
  sensitive   = true
}

variable "max_entries" {
  type        = number
  default     = 5
  description = "The maximum number of entries that this prefix list can contain."
}

variable "entry" {
  type        = list(any)
  default     = []
  description = "Can be specified multiple times for each prefix list entry."
}

variable "existing_sg_id" {
  type        = string
  default     = null
  description = "Provide existing security group id for updating existing rule"
}

variable "new_sg_ingress_rules_with_cidr_blocks" {
  type        = any
  default     = {}
  description = "Ingress rules with only cidr blocks. Should be used when new security group is been deployed."
}

variable "new_sg_ingress_rules_with_self" {
  type        = any
  default     = {}
  description = "Ingress rules with only self. Should be used when new security group is been deployed."
}

variable "new_sg_ingress_rules_with_source_sg_id" {
  type        = any
  default     = {}
  description = "Ingress rules with only source security group id. Should be used when new security group is been deployed."
}

variable "new_sg_ingress_rules_with_prefix_list" {
  type        = any
  default     = {}
  description = "Ingress rules with only prefix list ids. Should be used when new security group is been deployed."
}

variable "existing_sg_ingress_rules_with_cidr_blocks" {
  type        = any
  default     = {}
  description = "Ingress rules with only cidr blocks. Should be used when there is existing security group."
}

variable "existing_sg_ingress_rules_with_self" {
  type        = any
  default     = {}
  description = "Ingress rules with only source security group id. Should be used when new security group is been deployed."
}

variable "existing_sg_ingress_rules_with_source_sg_id" {
  type        = any
  default     = {}
  description = "Ingress rules with only prefix list ids. Should be used when there is existing security group."
}

variable "existing_sg_ingress_rules_with_prefix_list" {
  type        = any
  default     = {}
  description = "Ingress rules with only prefix_list. Should be used when new security group is been deployed."
}

variable "new_sg_egress_rules_with_cidr_blocks" {
  type        = any
  default     = {}
  description = "Egress rules with only cidr_blockd. Should be used when new security group is been deployed."
}

variable "new_sg_egress_rules_with_self" {
  type        = any
  default     = {}
  description = "Egress rules with only self. Should be used when new security group is been deployed."
}

variable "new_sg_egress_rules_with_source_sg_id" {
  type        = any
  default     = {}
  description = "Egress rules with only source security group id. Should be used when new security group is been deployed."
}

variable "new_sg_egress_rules_with_prefix_list" {
  type        = any
  default     = {}
  description = "Egress rules with only prefix list ids. Should be used when new security group is been deployed."
}

variable "existing_sg_egress_rules_with_cidr_blocks" {
  type        = any
  default     = {}
  description = "Ingress rules with only cidr block. Should be used when there is existing security group."
}

variable "existing_sg_egress_rules_with_self" {
  type        = any
  default     = {}
  description = "Egress rules with only self. Should be used when there is existing security group."
}

variable "existing_sg_egress_rules_with_source_sg_id" {
  type        = any
  default     = {}
  description = "Egress rules with only source security group id. Should be used when there is existing security group."
}

variable "existing_sg_egress_rules_with_prefix_list" {
  type        = any
  default     = {}
  description = "Egress rules with only prefic ist ids. Should be used when there is existing security group."
}

variable "new_sg" {
  type        = bool
  default     = true
  description = "Flag to control creation of new security group."
}

variable "sg_description" {
  type        = string
  default     = null
  description = "Security group description. Defaults to Managed by Terraform. Cannot be empty string. NOTE: This field maps to the AWS GroupDescription attribute, for which there is no Update API. If you'd like to classify your security groups in a way that can be updated, use tags."
}

variable "prefix_list_address_family" {
  type        = string
  default     = "IPv4"
  description = "(Required, Forces new resource) The address family (IPv4 or IPv6) of prefix list."
}