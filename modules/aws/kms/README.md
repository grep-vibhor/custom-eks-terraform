# KMS key terraform module

## Resources

Creates KMS key in with given key alias and in specified region. By default, the alias is `master`.

KMS key is able to:
- be used by CloudWatch logs
- be used by Autoscaling, for example to create KMS encrypted EBS volumes
- be used by CloudFront to deliver logs
- be used by EFS 

Now you can start with playing around `terraform plan` and `terraform apply`.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.39.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.39.0 |

## Resources

| Name | Type |
|------|------|
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_iam_policy_document.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS Account id | `string` | n/a | yes |
| <a name="input_environment_type"></a> [environment\_type](#input\_environment\_type) | Type of the environment. Can be `pre-prd` \| `prd` \| `sbx` \|`dev` \| `stage` \| `pentest` \| `qa`. | `string` | n/a | yes |
| <a name="input_kms_name"></a> [kms\_name](#input\_kms\_name) | KMS key name | `string` | `"master"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_alias_arn"></a> [kms\_alias\_arn](#output\_kms\_alias\_arn) | n/a |
| <a name="output_kms_alias_name"></a> [kms\_alias\_name](#output\_kms\_alias\_name) | n/a |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | n/a |
