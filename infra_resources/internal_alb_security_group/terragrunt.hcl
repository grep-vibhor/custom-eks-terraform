include "root" {
  path = find_in_parent_folders()
}

locals {
  global_var = read_terragrunt_config(find_in_parent_folders("global.hcl"))
}

terraform {
  source = "${local.global_var.inputs.module_source_path}/aws/security_group"
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

#Ordering of applying dependencies
dependencies {
  paths = ["../vpc"]
}

inputs = {
  sg_name               = "${local.global_var.inputs.org_name}-private-ingress-group-sg"
  sg_description        = "EKS ${local.global_var.inputs.org_name}-private-ingress-group-sg allows connections from VPN in private subnets"
  vpc_id = dependency.vpc.outputs.vpc_id
  region       = local.global_var.inputs.region
  new_sg_ingress_rules_with_cidr_blocks = [{
    rule_count  = 1
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = [local.global_var.inputs.vpn_cidr_source]
    description = "Allow http traffic."
  },
    {
      rule_count  = 2
      from_port   = 443
      protocol    = "tcp"
      to_port     = 443
      cidr_blocks = [local.global_var.inputs.vpn_cidr_source]
      description = "Allow https traffic dub-VPN"
    }
  ]

  ## EGRESS Rules
  new_sg_egress_rules_with_cidr_blocks = [{
    rule_count  = 1
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All outbound traffic dub-VPN"
  }]
}

