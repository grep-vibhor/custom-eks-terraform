## This had to be implemented using reference to cluster autoscaler module declared by us and not directly via invoking as like in VPC CNI and Kube proxy
## Because this particular resource used helm_release and kubernetes provider which needs data block to get eks cluster details dynamically which I couldn't do and got following error
#module.cluster_autoscaler[0].module.helm_addon.module.irsa[0].kubernetes_service_account_v1.irsa[0]: Creating...
#╷
#│ Error: Post "http://localhost/api/v1/namespaces/kube-system/serviceaccounts": dial tcp 127.0.0.1:80: connect: connection refused
#│
#│   with module.cluster_autoscaler[0].module.helm_addon.module.irsa[0].kubernetes_service_account_v1.irsa[0],
#│   on ../irsa/main.tf line 37, in resource "kubernetes_service_account_v1" "irsa":
#│   37: resource "kubernetes_service_account_v1" "irsa" {
########
include "root" {
  path = find_in_parent_folders()
}

locals {
  global_var = read_terragrunt_config(find_in_parent_folders("global.hcl"))
}

terraform {
  source = "${local.global_var.inputs.module_source_path}/kubernetes/efs-csi-driver"
}

dependency "eks" {
  config_path                             = "../../eks"
  skip_outputs                            = false
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    cluster_primary_security_group_id = "sg-12346758999"
    cluster_security_group_id         = "sg-12346758"
    eks_cluster_id                    = "eks-cluster"
    eks_cluster_version               = "1.27"
  }
}

##Ordering of applying dependencies
## nodegroups dependency is not useful while applying but is useful when destroying because when destroying, if it would only depend on eks then it would start destroying EKS Cluster w/o removing NGs

dependencies {
  paths = ["../../eks","../../nodegroups/devops"]
}

inputs = {
  region           = local.global_var.inputs.region
  cluster_id       = dependency.eks.outputs.eks_cluster_id
}




