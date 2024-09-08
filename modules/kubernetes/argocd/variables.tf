variable "region" {}

variable "cluster_id" {}

variable "argocd_helm_repo" {}

variable "argocd_helm_chart_version" {}

variable "argocd_host" {}

variable "argocd_full_domain_path" {}

variable "acm_certificate_arn" {}

variable "namespace" {}

variable "create_namespace" {}

variable "timeout" {
  default = 1200
}

variable "node_selector_key" {}

variable "node_selector_value" {}

variable "tolerations_key" {}

variable "tolerations_value" {}

variable "load_balancer_identifier" {}

variable "load_balancer_subnets" {}

variable "load_balancer_security_groups" {}

variable "controller_replicas" {}

variable "server_replicas" {}

variable "repoServer_replicas" {}
