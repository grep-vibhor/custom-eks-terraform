# VPC module

## Resources

Creates VPC with predefined subnets. Only `/22` CIDR range supported.

VPC has enabled flow log and attached Internet Gateway.

Attached VPC endpoints:
- DynamoDB
- EC2
- ECR
- ECS
- KMS
- S3
- SSM
- STS

Subnets:
- Three private subnets of size `/24`.
    - Doesn't have public IP enabled.
    - All EC2, EKS, private ALBs should be created here.
- Three public subnets of size `/26`.
    - Public IP enabled.
    - Used to provision public ALBs.
    - Three NAT instances per zone.
- Three gateway subnets of size `/28`. Reserved for NGFW. Not yet used.
    - Will be used to intercept Internet facing traffic to move it to NGFW for analysis.

If the Pod Subnet enabled. It will attach secondary VPC CIDR range (default `100.64.0.0/16`) and create three `/18` subnets which can be used by EKS pods.

## Terraform

Create `backend.tf` file and adjust `key` according to pattern: `<Account name>/<region name>/vpc/<vpc name>.tfstate`, like:

Execute this command to initialise Terraform.

```shell
terraform init
```

Now you can start with playing around `terraform plan` and `terraform apply`.

# Certain parameters can lead to re-creation of resources in AWS & so ideally should not be modified after the initial run. Following are the details:

| Parameter      | Re-creates resources |
| ----------- | ----------- |
| vpc\_name | Yes |
| account\_id | Yes |
| region | Yes |
| account\_name | Yes |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.63.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.47.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/terraform-aws-vpc | n/a |
| <a name="module_vpc_endpoints"></a> [vpc\_endpoints](#module\_vpc\_endpoints) | ./modules/terraform-aws-vpc/modules/vpc-endpoints | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_security_group.vpc_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_availability_zones.zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name                                                                                                                               | Description                                                                                              | Type | Default | Required |
|------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id)                                                                 | AWS Account id                                                                                           | `string` | n/a | yes |
| <a name="input_account_name"></a> [account\_name](#input\_account\_name)                                                           | AWS Account name                                                                                         | `string` | n/a | yes |
| <a name="input_cidr"></a> [cidr](#input\_cidr)                                                                                     | VPC CIDR. Supports only /22 netmask                                                                      | `string` | n/a | yes |
| <a name="input_default_security_group_egress"></a> [default\_security\_group\_egress](#input\_default\_security\_group\_egress)    | n/a                                                                                                      | `list(map(string))` | `[]` | no |
| <a name="input_default_security_group_ingress"></a> [default\_security\_group\_ingress](#input\_default\_security\_group\_ingress) | n/a                                                                                                      | `list(map(string))` | `[]` | no |
| <a name="input_enable_pod_subrange"></a> [enable\_pod\_subrange](#input\_enable\_pod\_subrange)                                    | Enable dedicated pod subrange                                                                            | `bool` | `false` | no |
| <a name="input_environment_type"></a> [environment\_type](#input\_environment\_type)                                               | Type of the environment. Can be `pre-prd` \                                                              | `prd` \| `sbx` \|`dev` \| `stage` \| `pentest` \| `qa`. | `string` | n/a | yes |
| <a name="input_flow_log_retention_in_days"></a> [flow\_log\_retention\_in\_days](#input\_flow\_log\_retention\_in\_days)           | Specifies the number of days you want to retain log events in the specified log group for VPC flow logs. | `number` | `14` | no |
| <a name="input_global_tags"></a> [global\_tags](#input\_tags)                                                                      | Global module tags                                                                                       | `map(string)` | `{}` | no |
| <a name="input_kms_arn"></a> [kms\_arn](#input\_kms\_arn)                                                                          | KMS ARN used for flow log encryption                                                                     | `string` | n/a | yes |
| <a name="input_pod_subrange"></a> [pod\_subrange](#input\_pod\_subrange)                                                           | Pod subrange                                                                                             | `string` | `"100.64.0.0/16"` | no |
| <a name="input_region"></a> [region](#input\_region)                                                                               | AWS region                                                                                               | `string` | n/a | yes |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name)                                                                    | Role name to assume                                                                                      | `string` | `"terraform-management"` | no |
| <a name="input_tags"></a> [tags](#input\_tags)                                                                                     | Tags applied to resources                                                                                | `map(string)` | `{}` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name)                                                                       | VPC name                                                                                                 | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_route_table_id"></a> [default\_route\_table\_id](#output\_default\_route\_table\_id) | n/a |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | n/a |
| <a name="output_endpoints"></a> [endpoints](#output\_endpoints) | VPC endpoints |
| <a name="output_gateway_route_table_ids"></a> [gateway\_route\_table\_ids](#output\_gateway\_route\_table\_ids) | n/a |
| <a name="output_gateway_subnet_arns"></a> [gateway\_subnet\_arns](#output\_gateway\_subnet\_arns) | n/a |
| <a name="output_gateway_subnets"></a> [gateway\_subnets](#output\_gateway\_subnets) | n/a |
| <a name="output_gateway_subnets_cidr_blocks"></a> [gateway\_subnets\_cidr\_blocks](#output\_gateway\_subnets\_cidr\_blocks) | n/a |
| <a name="output_gateway_subnets_ipv6_cidr_blocks"></a> [gateway\_subnets\_ipv6\_cidr\_blocks](#output\_gateway\_subnets\_ipv6\_cidr\_blocks) | n/a |
| <a name="output_igw_arn"></a> [igw\_arn](#output\_igw\_arn) | n/a |
| <a name="output_igw_id"></a> [igw\_id](#output\_igw\_id) | n/a |
| <a name="output_nat_ids"></a> [nat\_ids](#output\_nat\_ids) | n/a |
| <a name="output_nat_public_ips"></a> [nat\_public\_ips](#output\_nat\_public\_ips) | n/a |
| <a name="output_natgw_ids"></a> [natgw\_ids](#output\_natgw\_ids) | n/a |
| <a name="output_pod_route_table_ids"></a> [pod\_route\_table\_ids](#output\_pod\_route\_table\_ids) | n/a |
| <a name="output_pod_subnet_arns"></a> [pod\_subnet\_arns](#output\_pod\_subnet\_arns) | n/a |
| <a name="output_pod_subnets"></a> [pod\_subnets](#output\_pod\_subnets) | n/a |
| <a name="output_pod_subnets_cidr_blocks"></a> [pod\_subnets\_cidr\_blocks](#output\_pod\_subnets\_cidr\_blocks) | n/a |
| <a name="output_pod_subnets_ipv6_cidr_blocks"></a> [pod\_subnets\_ipv6\_cidr\_blocks](#output\_pod\_subnets\_ipv6\_cidr\_blocks) | n/a |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | n/a |
| <a name="output_private_subnet_arns"></a> [private\_subnet\_arns](#output\_private\_subnet\_arns) | n/a |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | n/a |
| <a name="output_private_subnets_cidr_blocks"></a> [private\_subnets\_cidr\_blocks](#output\_private\_subnets\_cidr\_blocks) | n/a |
| <a name="output_private_subnets_ipv6_cidr_blocks"></a> [private\_subnets\_ipv6\_cidr\_blocks](#output\_private\_subnets\_ipv6\_cidr\_blocks) | n/a |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | n/a |
| <a name="output_public_subnet_arns"></a> [public\_subnet\_arns](#output\_public\_subnet\_arns) | n/a |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | n/a |
| <a name="output_public_subnets_cidr_blocks"></a> [public\_subnets\_cidr\_blocks](#output\_public\_subnets\_cidr\_blocks) | n/a |
| <a name="output_public_subnets_ipv6_cidr_blocks"></a> [public\_subnets\_ipv6\_cidr\_blocks](#output\_public\_subnets\_ipv6\_cidr\_blocks) | n/a |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | n/a |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | n/a |
| <a name="output_vpc_flow_log_cloudwatch_iam_role_arn"></a> [vpc\_flow\_log\_cloudwatch\_iam\_role\_arn](#output\_vpc\_flow\_log\_cloudwatch\_iam\_role\_arn) | n/a |
| <a name="output_vpc_flow_log_destination_arn"></a> [vpc\_flow\_log\_destination\_arn](#output\_vpc\_flow\_log\_destination\_arn) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC |
| <a name="output_vpc_secondary_cidr_blocks"></a> [vpc\_secondary\_cidr\_blocks](#output\_vpc\_secondary\_cidr\_blocks) | n/a |
