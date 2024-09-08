include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${local.global_var.inputs.module_source_path}/aws/vpc"
}

locals {
  global_var = read_terragrunt_config(find_in_parent_folders("global.hcl"))
}

inputs = {
  vpc_cidr     = "10.146.0.0/18"
  zones        = local.global_var.inputs.vpc_zones
  region       = local.global_var.inputs.region
  vpc_name     = "${local.global_var.inputs.org_name}-${local.global_var.inputs.tags.env}-eks-cluster-vpc"
  ##https://www.subnet-calculator.com/cidr.php
  private_subnet_cidr_blocks = ["10.146.48.0/21", "10.146.32.0/20", "10.146.0.0/19"]
  public_subnet_cidr_blocks  = ["10.146.62.0/24", "10.146.60.0/23", "10.146.56.0/22"]
  gateway_subnet_cidr_blocks = ["10.146.63.0/25","10.146.63.128/26","10.146.63.192/26"] ## Small subnets, its a requirement from VPC module to create gateway subnets but we are not using it
  enable_pod_subrange        = false
  single_nat_gateway         = true
  tags                       = local.global_var.inputs.tags
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.global_var.inputs.org_name}-${local.global_var.inputs.tags.env}-cluster" = "shared"
    "kubernetes.io/role/elb"                                                    = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${local.global_var.inputs.org_name}-${local.global_var.inputs.tags.env}-cluster" = "shared"
    "kubernetes.io/role/internal-elb"                                           = 1
  }
  pod_subnet_tags = {
    "kubernetes.io/cluster/${local.global_var.inputs.org_name}-${local.global_var.inputs.tags.env}-cluster" = "shared"
    "kubernetes.io/role/internal-elb"                                           = 1
  }
}

