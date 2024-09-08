include "root" {
  path = find_in_parent_folders()
}

locals {
  global_var = read_terragrunt_config(find_in_parent_folders("global.hcl"))
}

terraform {
  source = local.global_var.inputs.eks_add_ons_module_path
}

dependency "eks" {
  config_path                             = "../../eks"
  skip_outputs                            = false
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    cluster_primary_security_group_id = "sg-12346758999"
    cluster_security_group_id         = "sg-12346758"
    eks_cluster_id                    = "eks-staging-cluster"
    eks_cluster_version               = "1.21"
  }
}

##Ordering of applying dependencies
## nodegroups dependency is not useful while applying but is useful when destroying because when destroying, if it would only depend on eks then it would start destroying EKS Cluster w/o removing NGs

dependencies {
  paths = ["../../eks","../../nodegroups/devops"]
}

inputs = {
  eks_cluster_id = dependency.eks.outputs.eks_cluster_id
  # Self-managed Add-ons
  enable_amazon_eks_vpc_cni = true
  amazon_eks_vpc_cni_config = {}
}