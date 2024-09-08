IMP Points:

## We can this module for deploying EFS With Mount targets. This module creates following resources.
1. EFS
2. EFS Mount targets
3. EFS SecurityGroup

## Features of module.
1. It will deploy a encrypted filesystem 
3. Throughput mode for the file system is set to "provisioned". So, Pass throughput number using variable named " provisioned_throughput_in_mibps". defaults 0 if not passed.
4. It deploys mount targets in private subnets and associates sg for each mount target.
5. Securitygroup allows 2049 Port from vpc_cidr.


## Find below availabe parameters and required parameters for creating resources

| Name          | Type          | Required | description |
| ------------- | ------------- | -------- | -----------
| encrypted     | boolean       | optional | whether file should be encrypted or not . If true, kms_key_id is required             
| kms_key_name    | string        | optional | if encrypted is set to true, this is manadatory             
| transition_to_ia | string     | optional | An optional lifecycle rule for EFS. If you want to apply lifecycle rule to EFS, set the value with any of the following values.( "AFTER_7_DAYS", "AFTER_14_DAYS", "AFTER_30_DAYS", "AFTER_60_DAYS", "AFTER_90_DAYS" )
| efs_throughput_mode | string     | optional | An optional throughput mode for efs filesystem, default to "provisioned". Available values (bursting, provisioned )
| provisioned_throughput_in_mibps | string     | optional | The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with throughput_mode set to provisioned. defult to 0.

## Module usage example:

module "efs" {
  source = "git@github.com:terraform-modules.git//aws/efs?ref=master"
  region                          = var.region
  kms_key_name                    = "localtest-master-key"
  encrypted                       = true
  transition_to_ia                = "AFTER_7_DAYS"
  efs_throughput_mode             = "provisioned"
  provisioned_throughput_in_mibps = "10"
  efs_mount_targets_subnet_ids    = module.vpc.private_subnets
  vpc_cidr                        = var.cidr
  efs_name                        = "efstest"
  env_name                        = var.env_name
  vpc_id                          = module.vpc.vpc_id
}

##  Note 
Dependent Module:
  VPC