output "user_arn" {
  value = aws_iam_user.user.arn
}

output "user_name" {
  value = aws_iam_user.user.name
}

output "user_id" {
  value = aws_iam_user.user.unique_id
}

output "user_tags_all" {
  value = aws_iam_user.user.tags_all
}