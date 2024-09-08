include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${local.global_var.inputs.module_source_path}/kubernetes/ebs-csi-driver"
}

locals {
  global_var = read_terragrunt_config(find_in_parent_folders("global.hcl"))
}


dependency "eks" {
  config_path                             = "../../eks"
  skip_outputs                            = false
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    cluster_primary_security_group_id = "sg-12346758999"
    cluster_security_group_id         = "sg-12346758"
    eks_cluster_id                    = "eks-cluster"
    eks_cluster_version               = "1.21"
    eks_oidc_provider_arn             = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/123456789012434252454534535653"
  }
}

dependency "ebs_csi_driver_role" {
  config_path                             = "../../ebs-csi-driver-role"
  skip_outputs                            = false
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    role_arn             = "arn:aws:iam::123456789012:role/some-role"
  }
}

dependency "kms" {
  config_path                             = "../../kms"
  skip_outputs                            = false
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/staging-key"
  }
}

##Ordering of applying dependencies
## nodegroups dependency is not useful while applying but is useful when destroying because when destroying, if it would only depend on eks then it would start destroying EKS Cluster w/o removing NGs

dependencies {
  paths = ["../../ebs-csi-driver-role", "../../kms", "../../eks", "../../nodegroups/devops"]
}


inputs = {
  region           = local.global_var.inputs.region
  aws_ebs_csi_driver_helm_repo = local.global_var.inputs.aws_ebs_csi_driver_helm_repo
  eks_cluster_id    = dependency.eks.outputs.eks_cluster_id
  ebs_kms_key_arn   = dependency.kms.outputs.kms_key_arn
  oidc_provider_arn = dependency.eks.outputs.eks_oidc_provider_arn
  env_name          = local.global_var.inputs.env
  ebs_role_arn = dependency.ebs_csi_driver_role.outputs.role_arn
  aws_ebs_csi_driver_helm_chart_version = local.global_var.inputs.aws_ebs_csi_driver_helm_chart_version
  csi_file_system = local.global_var.inputs.csi_file_system
}