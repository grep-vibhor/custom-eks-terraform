include "root" {
  path = find_in_parent_folders()
}
locals {
  global_var = read_terragrunt_config(find_in_parent_folders("global.hcl"))
}

terraform {
  source = local.global_var.inputs.eks_blue_prints_module_path
}


generate "cluster_auth" {
  path      = "cluster_auth.tf"
  if_exists = "overwrite"
  contents  = <<EOF
##############################
# Fetch Cluster Details     ## 
##############################
data "aws_eks_cluster" "kubernetes_cluster" {
  name  = module.aws_eks.cluster_id
}

data "aws_eks_cluster_auth" "kubernetes_cluster" {
  name  = module.aws_eks.cluster_id
}
  
##############################
# The helm provider block establishes your identity to your Kubernetes cluster. 
# The host and the cluster_ca_certificate use your aws_eks_cluster state data source to construct a method for logging in to your cluster. 
# short-lived token to authenticate to your EKS cluster.
#########################################
provider "helm" {
  kubernetes {
  host                   = element(concat(data.aws_eks_cluster.cluster[*].endpoint, [""]), 0)
  cluster_ca_certificate = base64decode(element(concat(data.aws_eks_cluster.cluster[*].certificate_authority.0.data, [""]), 0))
  token                  = element(concat(data.aws_eks_cluster_auth.kubernetes_cluster[*].token, [""]), 0)
  }
}

provider "kubernetes" {
  host                   = element(concat(data.aws_eks_cluster.cluster[*].endpoint, [""]), 0)
  cluster_ca_certificate = base64decode(element(concat(data.aws_eks_cluster.cluster[*].certificate_authority.0.data, [""]), 0))
  token                  = element(concat(data.aws_eks_cluster_auth.kubernetes_cluster[*].token, [""]), 0)
}
EOF
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

dependency "kms" {
  config_path                             = "../kms"
  skip_outputs                            = false
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    kms_key_arn = "arn:aws:kms:eu-west-1:123456789012:key/some-key"
  }
}

dependency "iam-role" {
  config_path                             = "../eks-worker-node-role"
  skip_outputs                            = false
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    role_arn = "arn:aws:iam::123456789012:role/some-role"
  }
}

##Ordering of applying dependencies
dependencies {
  paths = ["../kms" ,"../vpc", "../eks-worker-node-role"]
}


inputs = {
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false
  cluster_ip_family               = "ipv4"
  cluster_name                    = "${local.global_var.inputs.org_name}-${local.global_var.inputs.tags.env}-cluster"
  cluster_version                 = local.global_var.inputs.eks_version
  control_plane_subnet_ids        = dependency.vpc.outputs.private_subnets
  cluster_kms_key_arn             = dependency.kms.outputs.kms_key_arn
  iam_role_name                   = "${local.global_var.inputs.org_name}-${local.global_var.inputs.tags.env}-cluster-role"
  map_users                       = local.global_var.inputs.eks_auth_map_users
  map_roles = concat(
    local.global_var.inputs.eks_auth_map_roles,
    [{
      rolearn  = dependency.iam-role.outputs.role_arn,
      username = "system:node:{{EC2PrivateDNSName}}",
      groups   = ["system:bootstrappers", "system:nodes"]
    }]
  )
  #-------------------------------
  # EKS Cluster CloudWatch Logging
  #-------------------------------
  create_cloudwatch_log_group = false
  cluster_enabled_log_types   = []

  vpc_id = dependency.vpc.outputs.vpc_id
  tags   = local.global_var.inputs.tags
  cluster_timeouts = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  cluster_security_group_additional_rules = {
    vpn-access = {
      description                   = "All ports from VPN"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      cidr_blocks = [local.global_var.inputs.vpn_cidr_source]
      # To allow VPN access to Kube API Server
    }
    vpn-gateway-access = {
      description                   = "All ports from dub-gw"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      cidr_blocks = [local.global_var.inputs.vpn_gw_source]
      # To allow VPN access to Kube API Server
    }
  }

  # EKS Cluster has 2 Security Groups - Primary Security Group and Cluster Security Group
  # In addition to these 2 there is another SG created for managed NGs i.e. for following default NG, a new SG (apart from Cluster SG and Primary SG) will be created
  # Following rule will be added to that new SG i.e. to nodes of Default NG

  node_security_group_additional_rules = {
    allports = {
      description                   = "ALL ports from Cluster SG"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      source_cluster_security_group = true
      # With this Cluster Security Group (NOT primary SG) is added to rule. And Same Cluster Security Group is attached to other NGs like devops NG etc. So with this rule, Other NGs will be able to communicate to this default NG
    }
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    allow-all-outbound = {
      description = "Allow All Outbound Connections"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  managed_node_groups = {
    default-ng = {
      node_group_name          = "default-ng"
      enable_node_group_prefix = false
      instance_types           = ["t3.medium","t2.medium"]
      subnet_ids               = dependency.vpc.outputs.private_subnets
      ami_type                 = "AL2_x86_64" # AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, BOTTLEROCKET_x86_64, BOTTLEROCKET_ARM_64
      capacity_type            = "SPOT"
      desired_size = 1
      max_size     = 5
      min_size     = 0
      public_ip                = false
      enable_monitoring        = false
      create_launch_template   = true
      block_device_mappings = [
        {
          "device_name" : "/dev/xvda",
          "delete_on_termination" : true
          "encrypted" : true
          "kms_key_id" : dependency.kms.outputs.kms_key_arn
          "volume_size" : "20"
          "volume_type" : "gp3"
        }
      ]
    }
  }
}
