variable "cluster_id" {}
variable "image_repository" {
  description = "aws-load-balancer-controller image repository"
  type        = string
  default     = ""
}
variable "region" {}
# variable "replicas" {
#   description = "aws-load-balancer-controller replica count"
#   type        = number
#   default     = 1
# }

variable "enableBackendSecurityGroup" {
  type = bool
  description = "enables shared security group for backend traffic # https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.5/deploy/security_groups/"
}
