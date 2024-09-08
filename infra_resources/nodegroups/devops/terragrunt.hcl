include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = local.global_var.inputs.eks_managed_node_group_module_path
}

locals {
  global_var = read_terragrunt_config(find_in_parent_folders("global.hcl"))
}

dependency "vpc" {
  config_path                             = "../../vpc"
  skip_outputs                            = false
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    vpc_id          = "fake-vpc-id"
    vpc_cidr_block  = "10.0.0.0/16"
    private_subnets = ["subnet-123455", "subnet-1498458"]
  }
}

dependency "eks" {
  config_path                             = "../../eks"
  skip_outputs                            = false
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    cluster_primary_security_group_id = "sg-12346758999"
    cluster_security_group_id         = "sg-12346758"
    worker_node_security_group_id = "sg-12346758"
    eks_cluster_id                    = "eks-staging-cluster"
    eks_cluster_version               = "1.21"

  }
}


dependency "kms" {
  config_path                             = "../../kms"
  skip_outputs                            = false
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/some-key"
  }
}

dependency "iam-role" {
  config_path                             = "../../eks-worker-node-role"
  skip_outputs                            = false
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    role_arn = "arn:aws:role:us-east-1:123456789012:key/some-role"
  }
}

##Ordering of applying dependencies
dependencies {
  paths = ["../../kms", "../../vpc", "../../eks", "../../eks-worker-node-role"]
}

inputs = {
  name            = "devops-ng"
  use_name_prefix = false
  launch_template_name = "${dependency.eks.outputs.eks_cluster_id}-devops-ng"
  launch_template_use_name_prefix = false
  cluster_name    = dependency.eks.outputs.eks_cluster_id
  cluster_version = dependency.eks.outputs.eks_cluster_version

  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnets

  // The following variables are necessary if you decide to use the module outside of the parent EKS module context.
  // Without it, the security groups of the nodes are empty and thus won't join the cluster.
  cluster_primary_security_group_id = dependency.eks.outputs.cluster_primary_security_group_id
  cluster_security_group_id         = dependency.eks.outputs.cluster_security_group_id
  vpc_security_group_ids = [
    dependency.eks.outputs.cluster_security_group_id, ## We need to add Cluster SG (Not Primary) to this NG explicitly
    dependency.eks.outputs.worker_node_security_group_id  ## We need to add Worker Node SG id (SG attached to default NG) to this NG explicitly
  ]


  ## 1 node is needed initially to kickstart argocd helm
  ## Cluster Autoscaler was not functioning with initial 0 nodes and gave following error
  ## predicate checking error: node(s) didn't match Pod's node affinity/selector; predicateName=NodeAffinity; reasons: node(s) didn't match Pod's node affinity/selector;
  min_size     = 3
  max_size     = 5
  desired_size = 3

  instance_types = ["m5.xlarge","c5.xlarge"]
  capacity_type  = "SPOT"

  ami_type               = "AL2_x86_64"
  public_ip              = false
  enable_monitoring      = false
  create_launch_template = true
  launch_template_tags   = local.global_var.inputs.tags
  launch_template_description = "Template for creating devops nodegroup in EKS"
  block_device_mappings = [
    {
      "device_name" : "/dev/xvda",
      "ebs" : {
        "delete_on_termination" : true
        "encrypted" : true
        "kms_key_id" : dependency.kms.outputs.kms_key_arn
        "volume_size" : "20"
        "volume_type" : "gp3"
      }
    }
  ]
  disable_api_termination = false
  create_iam_role         = false
  iam_role_arn            = dependency.iam-role.outputs.role_arn
  labels = {
    role = "devops"
  }
  taints = {
    dedicated = {
      key    = "dedicated"
      value  = "devops"
      effect = "NO_SCHEDULE"
    }
  }
  tags            = local.global_var.inputs.tags
}
