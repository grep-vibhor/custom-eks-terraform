include "root" {
  path = find_in_parent_folders()
}

locals {
  global_var = read_terragrunt_config(find_in_parent_folders("global.hcl"))
}

terraform {
  source = "${local.global_var.inputs.module_source_path}/aws/kms"
}

inputs = {
  account_id          = local.global_var.inputs.account_id
  region              = local.global_var.inputs.region
  kms_master_key_name = "${local.global_var.inputs.org_name}-${local.global_var.inputs.tags.env}-key"
  environment_type    = local.global_var.inputs.env
  tags                = local.global_var.inputs.tags
}

