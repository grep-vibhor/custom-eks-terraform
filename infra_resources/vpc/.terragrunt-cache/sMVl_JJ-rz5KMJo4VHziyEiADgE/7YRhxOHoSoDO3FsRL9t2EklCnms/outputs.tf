# 
# 
# // VPC
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "vpc_arn" {
  value = module.vpc.vpc_arn
}

output "vpc_secondary_cidr_blocks" {
  value = module.vpc.vpc_secondary_cidr_blocks
}

output "vpc_flow_log_cloudwatch_iam_role_arn" {
  value = module.vpc.vpc_flow_log_cloudwatch_iam_role_arn
}

output "vpc_flow_log_destination_arn" {
  value = module.vpc.vpc_flow_log_destination_arn
}

output "default_route_table_id" {
  value = module.vpc.default_route_table_id
}

output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}

output "igw_arn" {
  value = module.vpc.igw_arn
}

output "igw_id" {
  value = module.vpc.igw_id
}

output "nat_ids" {
  value = module.vpc.nat_ids
}

output "nat_public_ips" {
  value = module.vpc.nat_public_ips
}

output "natgw_ids" {
  value = module.vpc.natgw_ids
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "private_subnet_arns" {
  value = module.vpc.private_subnet_arns
}

output "private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks
}

output "private_subnets_ipv6_cidr_blocks" {
  value = module.vpc.private_subnets_ipv6_cidr_blocks
}

output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "public_subnet_arns" {
  value = module.vpc.public_subnet_arns
}

output "public_subnets_cidr_blocks" {
  value = module.vpc.public_subnets_cidr_blocks
}

output "public_subnets_ipv6_cidr_blocks" {
  value = module.vpc.public_subnets_ipv6_cidr_blocks
}

output "gateway_route_table_ids" {
  value = module.vpc.gateway_route_table_ids
}

output "gateway_subnets" {
  value = module.vpc.gateway_subnets
}

output "gateway_subnet_arns" {
  value = module.vpc.gateway_subnet_arns
}

output "gateway_subnets_cidr_blocks" {
  value = module.vpc.gateway_subnets_cidr_blocks
}

output "gateway_subnets_ipv6_cidr_blocks" {
  value = module.vpc.gateway_subnets_ipv6_cidr_blocks
}

output "pod_route_table_ids" {
  value = module.vpc.pod_route_table_ids
}

output "pod_subnets" {
  value = module.vpc.pod_subnets
}

output "pod_subnet_arns" {
  value = module.vpc.pod_subnet_arns
}

output "pod_subnets_cidr_blocks" {
  value = module.vpc.pod_subnets_cidr_blocks
}

output "pod_subnets_ipv6_cidr_blocks" {
  value = module.vpc.pod_subnets_ipv6_cidr_blocks
}

// VPC endpoints
output "endpoints" {
  value = module.vpc_endpoints.endpoints
}