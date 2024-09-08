### Difference between generalPurpose and maxIO (https://aws.amazon.com/premiumsupport/knowledge-center/linux-efs-performance-modes/)
variable "efs_performance_mode" {
  description = "performance mode for elastic file system"
  default     = "generalPurpose"
}

variable "encrypted" {
  description = "encryption status"
  default     = true
}

variable "kms_key_arn" {
  description = "kms key name to use it for server side encryption"
  default     = null
}

variable "transition_to_ia" {
  description = "after how many days files should be transfered to EFS-IA"
  default     = "AFTER_7_DAYS"
}

variable "efs_throughput_mode" {
  description = "efs throughput mode type"
  default     = "provisioned"
}

variable "provisioned_throughput_in_mibps" {
  description = "The throughput, measured in MiB/s, that you want to provision for the file system"
  default     = 1
}

variable "region" {
  description = "aws region to deploy resources"
}

variable "efs_mount_targets_subnet_ids" {
  type        = list(string)
  description = "list of subnets to create efs mount targets"
}

variable "vpc_cidr" {}
variable "vpc_id" { description = "id of vpc" }
variable "efs_name" { description = "efs name" }

variable "env_name" {
  type        = string
  description = "Type of the environment. for example `pre-prd` | `prd` | `sbx` | `dev` | `stage` | `pentest` | `qa`."
}