include "root" {
  path = find_in_parent_folders()
}

locals {
  global_var = read_terragrunt_config(find_in_parent_folders("global.hcl"))
}

terraform {
  source = "${local.global_var.inputs.module_source_path}/aws/acm"
}

inputs = {
  region                    = local.global_var.inputs.region
  domain_name               = "*.k8s.fivexl.com"
  subject_alternative_names = ["k8s.fivexl.com","monitoring.fivexl.com"]
  tags                      = local.global_var.inputs.tags
  env_name                  = local.global_var.inputs.env
}

