variable "cluster_id" {}
variable "image_tag" {
  description = "cluster autoscaler image tag compatible with eks cluster version"
  type        = string
  default     = "v1.21.0"
}
variable "region" {}
variable "replicas" {
  description = "cluster autoscaler replica count"
  type        = number
  default     = 1
}
