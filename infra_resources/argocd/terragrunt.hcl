# Have to refer to external module - https://bitnami.com/stack/argo-cd/helm
# Because this particular resource used helm_release and kubernetes provider which needs data block to get eks cluster details dynamically which I couldn't do and got following error
#module.argocd[0].kubernetes_namespace_v1.this[0]: Creating...
#╷
#│ Error: Post "http://localhost/api/v1/namespaces": dial tcp 127.0.0.1:80: connect: connection refused
#│
#│   with module.argocd[0].kubernetes_namespace_v1.this[0],
#│   on argocd/main.tf line 10, in resource "kubernetes_namespace_v1" "this":
#│   10: resource "kubernetes_namespace_v1" "this" {
#│

include "root" {
  path = find_in_parent_folders()
}

locals {
  global_var = read_terragrunt_config(find_in_parent_folders("global.hcl"))
}

terraform {
  source = "${local.global_var.inputs.module_source_path}/kubernetes/argocd"
}

dependency "vpc" {
  config_path                             = "../vpc"
  skip_outputs                            = false
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    vpc_id          = "fake-vpc-id"
    vpc_cidr_block  = "10.0.0.0/16"
    private_subnets = ["subnet-123455", "subnet-1498458"]
  }
}

dependency "eks" {
  config_path                             = "../eks"
  skip_outputs                            = false
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    cluster_primary_security_group_id = "sg-12346758999"
    cluster_security_group_id         = "sg-12346758"
    eks_cluster_id                    = "eks-staging-cluster"
    eks_cluster_version               = "1.21"
  }
}

dependency "acm" {
  config_path                             = "../acm"
  skip_outputs                            = false
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:key/some-cert"
  }
}

dependency "alb_security_group" {
  config_path                             = "../internal_alb_security_group"
  skip_outputs                            = false
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    security_group_id = "sg-xxxxxxxxxxxxxxxxx"
    security_group_arn = "arn:aws:ec2:eu-west-1:123456789012:security-group/sg-xxxxxxxxxxxxxxxxx"
  }
}

##Ordering of applying dependencies
## nodegroups dependency is not useful while applying but is useful when destroying because when destroying, if it would only depend on eks then it would start destroying EKS Cluster w/o removing NGs

dependencies {
  paths = ["../acm", "../vpc", "../internal_alb_security_group", "../eks","../nodegroups/devops"]
}

inputs = {
  region = local.global_var.inputs.region
  cluster_id = dependency.eks.outputs.eks_cluster_id
  argocd_helm_repo   = local.global_var.inputs.argocd_helm_repo
  argocd_helm_chart_version  = local.global_var.inputs.argocd_helm_chart_version
  namespace        = "argocd"
  create_namespace = true
  argocd_host = local.global_var.inputs.argocd_host
  argocd_full_domain_path = local.global_var.inputs.argocd_full_domain_path
  acm_certificate_arn = dependency.acm.outputs.acm_certificate_arn
  node_selector_key = "role"
  node_selector_value = "devops"
  tolerations_key = "dedicated"
  tolerations_value = "devops"
  load_balancer_identifier = "${local.global_var.inputs.org_name}-private-ingress-group"
  load_balancer_subnets = join(", ",dependency.vpc.outputs.private_subnets)
  load_balancer_security_groups = dependency.alb_security_group.outputs.security_group_id
  controller_replicas = 1
  server_replicas = 1
  repoServer_replicas = 1
}