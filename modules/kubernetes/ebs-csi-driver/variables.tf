/*
Since, we are adding EBS-CSI Plugin, the following resources needed
*/
variable "region" {
  type = string
}
variable "ebs_kms_key_arn" {
  type = string
}
variable "eks_cluster_id" {
  type = string
}
variable "oidc_provider_arn" {
  type = string
}
variable "env_name" {
  type = string
}
variable "ebs_role_arn" {
  type = string
}
variable "aws_ebs_csi_driver_helm_repo" {
  type = string
}
variable "aws_ebs_csi_driver_helm_chart_version" {
  type = string
}
variable "csi_file_system" {
  type = string
}
