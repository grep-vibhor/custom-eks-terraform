output "role_arn" {
  value       = aws_iam_role.default.arn
  description = "The Amazon Resource Name (ARN) specifying the role."
}


output "role_name" {
  value       = aws_iam_role.default.name
  description = "Name of specifying the role."
}

output "instance_profile_name" {
  value       = data.aws_iam_instance_profiles.instance_profile.names
  description = "Name of specifying the role."
}

output "instance_profile_arn" {
  value       = data.aws_iam_instance_profiles.instance_profile.arns
  description = "Name of specifying the role."
}