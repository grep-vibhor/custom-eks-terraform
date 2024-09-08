output "security_group_id" {
  value       = var.new_sg ? aws_security_group.default.id : null
  description = "IDs on the AWS Security Groups associated with the instance."
}

output "security_group_arn" {
  value       = var.new_sg ? aws_security_group.default.arn : null
  description = "IDs on the AWS Security Groups associated with the instance."
}

output "security_group_tags" {
  value       = var.new_sg ? aws_security_group.default.tags : null
  description = "A mapping of public tags to assign to the resource."
}