locals {
  tags = merge({
    Name        = var.name
    Environment = var.environment
  }, { for k, v in var.tags : k => v if k != "Name" })
}

resource "aws_iam_role" "default" {
  name                  = var.name
  assume_role_policy    = var.assume_role_policy
  managed_policy_arns   = var.managed_policy_arns
  force_detach_policies = var.force_detach_policies
  path                  = var.path
  description           = var.description
  max_session_duration  = var.max_session_duration
  permissions_boundary  = var.permissions_boundary
  dynamic "inline_policy" {
    for_each = var.inline_policy
    content {
      name   = lookup(inline_policy.value, "name")
      policy = lookup(inline_policy.value, "policy")
    }
  }
  tags = local.tags
}

resource "aws_iam_policy" "default" {
  count  = var.policy_enabled ? 1 : 0
  name   = var.policy_name
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = var.policy_enabled ? 1 : 0
  role       = aws_iam_role.default.id
  policy_arn = aws_iam_policy.default.*.arn[0]
}

data "aws_iam_instance_profiles" "instance_profile" {
  depends_on = [aws_iam_role.default]
  role_name = var.name
}