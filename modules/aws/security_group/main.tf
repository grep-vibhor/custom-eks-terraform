resource "aws_security_group" "default" {
  name        = var.sg_name
  vpc_id      = var.vpc_id
  description = var.sg_description
  tags        = var.tags
  lifecycle {
    create_before_destroy = true
  }
}

##-----------------------------------------------------------------------------
## Below data resource is to get details of existing security group in your aws environment.
## Will be called when you provide existing security group id in 'existing_sg_id' variable.
##-----------------------------------------------------------------------------
data "aws_security_group" "existing" {
  count  = var.existing_sg_id != null ? 1 : 0
  id     = var.existing_sg_id
  vpc_id = var.vpc_id
}


##-----------------------------------------------------------------------------
## Below resource will deploy ingress security group rules for new security group created from this module.
##-----------------------------------------------------------------------------
# Security group rules with "cidr_blocks", but without "source_security_id" and "self"
resource "aws_security_group_rule" "new_sg_ingress_with_cidr_blocks" {
  for_each          = { for rule in var.new_sg_ingress_rules_with_cidr_blocks : rule.rule_count => rule }
  type              = "ingress"
  from_port         = each.value.from_port
  protocol          = each.value.protocol
  to_port           = each.value.to_port
  security_group_id = aws_security_group.default.id
  cidr_blocks       = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks  = lookup(each.value, "ipv6_cidr_blocks", null)
  description       = lookup(each.value, "description", null)
}

# Security group rules with "self", but without "source_security_id" and "cidr_blocks"
resource "aws_security_group_rule" "new_sg_ingress_with_self" {
  for_each          = { for rule in var.new_sg_ingress_rules_with_self : rule.rule_count => rule }
  type              = "ingress"
  from_port         = each.value.from_port
  protocol          = each.value.protocol
  to_port           = each.value.to_port
  security_group_id = aws_security_group.default.id
  self              = lookup(each.value, "self", true)
  description       = lookup(each.value, "description", null)
}

# Security group rules with "source_security_id", but without "cidr_blocks" and "self"
resource "aws_security_group_rule" "new_sg_ingress_with_source_sg_id" {
  for_each                 = { for rule in var.new_sg_ingress_rules_with_source_sg_id : rule.rule_count => rule }
  type                     = "ingress"
  from_port                = each.value.from_port
  protocol                 = each.value.protocol
  to_port                  = each.value.to_port
  source_security_group_id = each.value.source_security_group_id
  security_group_id        = aws_security_group.default.id
  description              = lookup(each.value, "description", null)
}


##-----------------------------------------------------------------------------
## Below resource will deploy ingress security group rules for existing security group.
##-----------------------------------------------------------------------------
# Security group rules with "cidr_blocks", but without "source_security_id" and "self"
resource "aws_security_group_rule" "existing_sg_ingress_cidr_blocks" {
  for_each          = { for rule in var.existing_sg_ingress_rules_with_cidr_blocks : rule.rule_count => rule }
  type              = "ingress"
  from_port         = each.value.from_port
  protocol          = each.value.protocol
  to_port           = each.value.to_port
  security_group_id = data.aws_security_group.existing[0].id
  cidr_blocks       = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks  = lookup(each.value, "ipv6_cidr_blocks", null)
  description       = lookup(each.value, "description", null)
}

# Security group rules with "self", but without "source_security_id" and "cidr_blocks"
resource "aws_security_group_rule" "existing_sg_ingress_with_self" {
  for_each          = { for rule in var.existing_sg_ingress_rules_with_self : rule.rule_count => rule }
  type              = "ingress"
  from_port         = each.value.from_port
  protocol          = each.value.protocol
  to_port           = each.value.to_port
  security_group_id = data.aws_security_group.existing[0].id
  self              = lookup(each.value, "self", true)
  description       = lookup(each.value, "description", null)
}

# Security group rules with "source_security_id", but without "cidr_blocks" and "self"
resource "aws_security_group_rule" "existing_sg_ingress_with_source_sg_id" {
  for_each                 = { for rule in var.existing_sg_ingress_rules_with_source_sg_id : rule.rule_count => rule }
  type                     = "ingress"
  from_port                = each.value.from_port
  protocol                 = each.value.protocol
  to_port                  = each.value.to_port
  source_security_group_id = each.value.source_security_group_id
  security_group_id        = data.aws_security_group.existing[0].id
  description              = lookup(each.value, "description", null)
}



##-----------------------------------------------------------------------------
## Below resource will deploy egress security group rules for new security group created from this module.
##-----------------------------------------------------------------------------
# Security group rules with "cidr_blocks", but without "source_security_id" and "self"
resource "aws_security_group_rule" "new_sg_egress_with_cidr_blocks" {
  for_each          = { for rule in var.new_sg_egress_rules_with_cidr_blocks : rule.rule_count => rule }
  type              = "egress"
  from_port         = each.value.from_port
  protocol          = each.value.protocol
  to_port           = each.value.to_port
  security_group_id = aws_security_group.default.id
  cidr_blocks       = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks  = lookup(each.value, "ipv6_cidr_blocks", null)
  description       = lookup(each.value, "description", null)
}

# Security group rules with "self", but without "source_security_id" and "cidr_blocks"
resource "aws_security_group_rule" "new_sg_egress_with_self" {
  for_each          = { for rule in var.new_sg_egress_rules_with_self : rule.rule_count => rule }
  type              = "egress"
  from_port         = each.value.from_port
  protocol          = each.value.protocol
  to_port           = each.value.to_port
  security_group_id = aws_security_group.default.id
  self              = lookup(each.value, "self", true)
  description       = lookup(each.value, "description", null)
}

# Security group rules with "source_security_id", but without "cidr_blocks" and "self"
resource "aws_security_group_rule" "new_sg_egress_with_source_sg_id" {
  for_each                 = { for rule in var.new_sg_egress_rules_with_source_sg_id : rule.rule_count => rule }
  type                     = "egress"
  from_port                = each.value.from_port
  protocol                 = each.value.protocol
  to_port                  = each.value.to_port
  source_security_group_id = each.value.source_security_group_id
  security_group_id        = aws_security_group.default.id
  description              = lookup(each.value, "description", null)
}

##-----------------------------------------------------------------------------
## Below resource will deploy egress security group rules for existing security group.
##-----------------------------------------------------------------------------
# Security group rules with "cidr_blocks", but without "source_security_id" and "self"
resource "aws_security_group_rule" "existing_sg_egress_with_cidr_blocks" {
  for_each          = { for rule in var.existing_sg_egress_rules_with_cidr_blocks : rule.rule_count => rule }
  type              = "egress"
  from_port         = each.value.from_port
  protocol          = each.value.protocol
  to_port           = each.value.to_port
  security_group_id = data.aws_security_group.existing[0].id
  cidr_blocks       = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks  = lookup(each.value, "ipv6_cidr_blocks", null)
  description       = lookup(each.value, "description", null)
}

# Security group rules with "self", but without "source_security_id" and "cidr_blocks"
resource "aws_security_group_rule" "existing_sg_egress_with_self" {
  for_each          = { for rule in var.existing_sg_egress_rules_with_self : rule.rule_count => rule }
  type              = "egress"
  from_port         = each.value.from_port
  protocol          = each.value.protocol
  to_port           = each.value.to_port
  security_group_id = data.aws_security_group.existing[0].id
  self              = lookup(each.value, "self", true)
  description       = lookup(each.value, "description", null)
}

# Security group rules with "source_security_id", but without "cidr_blocks" and "self"
resource "aws_security_group_rule" "existing_sg_egress_with_source_sg_id" {
  for_each                 = { for rule in var.existing_sg_egress_rules_with_source_sg_id : rule.rule_count => rule }
  type                     = "egress"
  from_port                = each.value.from_port
  protocol                 = each.value.protocol
  to_port                  = each.value.to_port
  source_security_group_id = each.value.source_security_group_id
  security_group_id        = data.aws_security_group.existing[0].id
  description              = lookup(each.value, "source_address_prefix", null)
}
