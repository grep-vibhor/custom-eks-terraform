data "aws_availability_zones" "zones" {}

###############################################
# Fetch information of KMS Key, by using name #       
###############################################
data "aws_kms_key" "master" {
  count  = var.flow_log_cloudwatch_log_group_kms_key_name != null ? 1 : 0
  key_id = "alias/${var.flow_log_cloudwatch_log_group_kms_key_name}"
}

locals {
  tags  = merge(var.global_tags, { for k, v in var.tags : k => v if k != "Name" })
  zones = slice(data.aws_availability_zones.zones.names, 0, 3)

  # public_subnet_range  = cidrsubnet(var.cidr, 2, 3)
  # gateway_subnet_range = cidrsubnet(local.public_subnet_range, 2, 3)
  vpc_name             = lower(replace(replace(var.vpc_name, "_", "-"), " ", "-"))
}

module "vpc" {
  # Based on version 3.0.0
  # Changes:
  # - add `gateway` subnets
  # - add `pod` subnets
  source = "./modules/terraform-aws-vpc"

  #name                  = "${local.vpc_name}-${var.environment_type}-vpc"
  name                  = local.vpc_name
  cidr                  = var.vpc_cidr
  secondary_cidr_blocks = var.enable_pod_subrange ? [var.pod_subrange] : []

  azs             = var.zones == null ? local.zones : var.zones
  # private_subnets = cidrsubnets(var.cidr, 2, 2, 2)
  # public_subnets  = cidrsubnets(local.public_subnet_range, 2, 2, 2)
  # gateway_subnets = cidrsubnets(local.gateway_subnet_range, 2, 2, 2)
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks
  gateway_subnets = var.gateway_subnet_cidr_blocks  
  pod_subnets     = var.enable_pod_subrange ? cidrsubnets(var.pod_subrange, 2, 2, 2) : []

  tags = local.tags
  public_subnet_tags = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags
  pod_subnet_tags = var.pod_subnet_tags

  # Defaults
  enable_ipv6            = false
  enable_dns_hostnames   = true
  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
  ##By default this value with be false. If someone wants single nat gateway for all private subnets, explicitly pass value to true.
  ##More info: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
  single_nat_gateway = var.single_nat_gateway

  # Flow logs
  enable_flow_log                                 = var.enable_vpc_flow_log
  create_flow_log_cloudwatch_log_group            = true
  create_flow_log_cloudwatch_iam_role             = true
  flow_log_cloudwatch_log_group_name_prefix       = "${local.vpc_name}/"
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_retention_in_days
  flow_log_cloudwatch_log_group_kms_key_id        = var.flow_log_cloudwatch_log_group_kms_key_name != null ? data.aws_kms_key.master[0].arn : null


  manage_default_security_group  = true
  default_security_group_ingress = var.default_security_group_ingress
  default_security_group_egress  = var.default_security_group_egress
}

resource "aws_security_group" "vpc_endpoint" {
  name        = "${local.vpc_name}-interface-endpoint"
  description = "Default VPC endpoint security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.vpc_name}-interface-endpoint"
  }
}

module "vpc_endpoints" {
  # Based on version 3.0.0
  source = "./modules/terraform-aws-vpc/modules/vpc-endpoints"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [aws_security_group.vpc_endpoint.id]

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = flatten([module.vpc.private_route_table_ids, module.vpc.public_route_table_ids, module.vpc.pod_route_table_ids])
      tags            = { Name = "${local.vpc_name}-s3" }
    },
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = flatten([module.vpc.private_route_table_ids, module.vpc.public_route_table_ids, module.vpc.pod_route_table_ids])
      tags            = { Name = "${local.vpc_name}-dynamodb" }
    },
    ##Reason for commenting
    ## We have a natgateway inplace for all private subnets to make an API calls to services.
    ## Interface endpoints enables services to call other services API's using private Ips.
    # ssm = {
    #   service             = "ssm"
    #   private_dns_enabled = true
    #   subnet_ids          = module.vpc.private_subnets
    #   tags                = { Name = "${local.vpc_name}-ssm" }
    # },
    # ssmmessages = {
    #   service             = "ssmmessages"
    #   private_dns_enabled = true
    #   subnet_ids          = module.vpc.private_subnets
    #   tags                = { Name = "${local.vpc_name}-ssmmessages" }
    # },
    # lambda = {
    #   service             = "lambda"
    #   private_dns_enabled = true
    #   subnet_ids          = module.vpc.private_subnets
    #   tags                = { Name = "${local.vpc_name}-lambda" }
    # },
    # ecs = {
    #   service             = "ecs"
    #   private_dns_enabled = true
    #   subnet_ids          = module.vpc.private_subnets
    #   tags                = { Name = "${local.vpc_name}-ecs" }
    # },
    # ecs_telemetry = {
    #   service             = "ecs-telemetry"
    #   private_dns_enabled = true
    #   subnet_ids          = module.vpc.private_subnets
    #   tags                = { Name = "${local.vpc_name}-ecs-telemetry" }
    # },
    # ec2 = {
    #   service             = "ec2"
    #   private_dns_enabled = true
    #   subnet_ids          = module.vpc.private_subnets
    #   tags                = { Name = "${local.vpc_name}-ec2-telemetry" }
    # },
    # ec2messages = {
    #   service             = "ec2messages"
    #   private_dns_enabled = true
    #   subnet_ids          = module.vpc.private_subnets
    #   tags                = { Name = "${local.vpc_name}-ec2messages-telemetry" }
    # },
    # ecr_api = {
    #   service             = "ecr.api"
    #   private_dns_enabled = true
    #   subnet_ids          = module.vpc.private_subnets
    #   tags                = { Name = "${local.vpc_name}-ecr.api" }
    # },
    # ecr_dkr = {
    #   service             = "ecr.dkr"
    #   private_dns_enabled = true
    #   subnet_ids          = module.vpc.private_subnets
    #   tags                = { Name = "${local.vpc_name}-ecr.dkr" }
    # },
    # kms = {
    #   service             = "kms"
    #   private_dns_enabled = true
    #   subnet_ids          = module.vpc.private_subnets
    #   tags                = { Name = "${local.vpc_name}-kms" }
    # },
    # Not supported in Canada
    # codedeploy = {
    #   service             = "codedeploy"
    #   private_dns_enabled = true
    #   subnet_ids          = module.vpc.private_subnets
    #   tags                = { Name = "${local.vpc_name}-codedeploy" }
    # },
    # codedeploy_commands_secure = {
    #   service             = "codedeploy-commands-secure"
    #   private_dns_enabled = true
    #   subnet_ids          = module.vpc.private_subnets
    #   tags                = { Name = "${local.vpc_name}-codedeploy-commands-secure" }
    # },
    # sts = {
    #   service             = "sts"
    #   private_dns_enabled = true
    #   subnet_ids          = module.vpc.private_subnets
    #   tags                = { Name = "${local.vpc_name}-sts" }
    # }
  }

  tags = local.tags
}