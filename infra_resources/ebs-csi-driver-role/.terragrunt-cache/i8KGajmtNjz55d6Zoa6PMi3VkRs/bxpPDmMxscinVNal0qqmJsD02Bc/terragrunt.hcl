include "root" {
  path = find_in_parent_folders()
}

locals {
  global_var = read_terragrunt_config(find_in_parent_folders("global.hcl"))
}

terraform {
  source = "${local.global_var.inputs.module_source_path}/aws/iam/iam-role"
}


dependency "eks" {
  config_path                             = "../eks"
  skip_outputs                            = false
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    cluster_primary_security_group_id = "sg-12346758999"
    cluster_security_group_id         = "sg-12346758"
    eks_cluster_id                    = "eks-staging-cluster"
    eks_cluster_version               = "1.27"
    eks_oidc_provider_arn             = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/123456789012434252454534535653"
  }
}


dependency "kms" {
  config_path                             = "../kms"
  skip_outputs                            = false
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs = {
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/some-key"
  }
}

##Ordering of applying dependencies
dependencies {
  paths = ["../eks", "../kms"]
}

inputs = {
  name        = "${dependency.eks.outputs.eks_cluster_id}-ebs-csi-driver-role"
  description = "${dependency.eks.outputs.eks_cluster_id}-ebs-csi-driver-role"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  region                    = local.global_var.inputs.region
  environment = local.global_var.inputs.env
  tags = {
    env = local.global_var.inputs.env
  }
  inline_policy = [
    {
      "name": "${dependency.eks.outputs.eks_cluster_id}-ebs-csi-driver-policy"
      "policy": templatefile("templates/ebs-csi-driver-managed-policy.tpl",
        {
          ebs_kms_key_id = dependency.kms.outputs.kms_key_arn
        }
      )
    }
  ]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = dependency.eks.outputs.eks_oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "oidc.eks.${local.global_var.inputs.region}.amazonaws.com/id/${split("/", dependency.eks.outputs.eks_oidc_provider_arn )[3]}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

