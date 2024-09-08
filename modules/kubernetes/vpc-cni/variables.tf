variable "cluster_id" {}
variable "region" {}
variable "amazon_eks_vpc_cni_config" {
    type        = any
    description = "ConfigMap of Amazon EKS VPC CNI add-on"
    default = {}
}
