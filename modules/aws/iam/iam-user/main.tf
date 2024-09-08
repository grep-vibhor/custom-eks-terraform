locals {
  tags = merge({
    Name        = var.user_name
    Environment = var.environment
  }, { for k, v in var.tags : k => v if k != "Name" })
}

resource "aws_iam_user" "user" {
  name                 = var.user_name
  path                 = var.path
  permissions_boundary = var.permissions_boundary
  force_destroy        = var.force_destroy
  tags                 = local.tags
}


resource "aws_iam_policy" "default" {
  count  = var.policy == {} ? 0 : 1
  name   = "${var.user_name}-policy"
  policy = var.policy
}

##Resource for attaching User Managed/AWS Managed Policies to user
resource "aws_iam_policy_attachment" "policy-attach" {
  count      = var.policy == {} ? 0 : 1
  name       = "${var.user_name}-attachment"
  users      = [aws_iam_user.user.name]
  policy_arn = aws_iam_policy.default[0].arn
}

##Resource for AWS/User Attaching Managed Policies
resource "aws_iam_policy_attachment" "managed-policy-attach" {
  count      = length(var.managed_policy_arns)
  name       = "${var.user_name}-attachment-${count.index}"
  users      = [aws_iam_user.user.name]
  policy_arn = var.managed_policy_arns[count.index]
}