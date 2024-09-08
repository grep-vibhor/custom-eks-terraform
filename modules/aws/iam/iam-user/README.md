<!-- BEGIN_TF_DOCS -->

# IAM User

## :label: Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | v4.12.0 |



## :gear: Resources

| Name | Type |
|------|------|
| [aws_iam_user.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/aws_iam_policy) | resource |
| [aws_iam_policy_attachment.managed-policy-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |

## :chains: Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Development environment to be added as a tag | `string` | `""` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | (Optional, default false) When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without force\_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed. | `bool` | `false` | no |
| <a name="input_path"></a> [path](#input\_path) | (Optional, default '/') Path in which to create the user. | `string` | `"/"` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | (Optional) The ARN of the policy that is used to set the permissions boundary for the user. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Key-value map of tags for the IAM user. | `map(any)` | `{}` | no |
| <a name="input_user_name"></a> [user\_name](#input\_user\_name) | The user's name. The name must consist of upper and lowercase alphanumeric characters with no spaces. You can also include any of the following characters: =,.@-\_.. User names are not distinguished by case. For example, you cannot create users named both 'TESTUSER' and 'testuser'. | `string` | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | The policy document should be use to create and associate to user. | `any` | `null` | no |
| <a name="input_managed_policy_arns"></a> [managed\_policy\_arns](#input\_managed\_policy\_arns) | (Optional, default '[]') list of AWS managed or User Managed Policies attach to user. | `list(string)` | `"[]"` | no |

## :hammer_and_wrench:  Outputs

| Name | Description |
|------|-------------|
| <a name="output_user_arn"></a> [user\_arn](#output\_user\_arn) | n/a |
| <a name="output_user_id"></a> [user\_id](#output\_user\_id) | n/a |
| <a name="output_user_name"></a> [user\_name](#output\_user\_name) | n/a |
| <a name="output_user_tags_all"></a> [user\_tags\_all](#output\_user\_tags\_all) | n/a |



<!-- END_TF_DOCS -->