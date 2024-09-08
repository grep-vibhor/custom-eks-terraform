###############################################
# Fetch information of KMS Key, by using name #       
###############################################
#data "aws_kms_key" "master" {
#  count  = var.kms_key_name != null ? 1 : 0
#  key_id = "alias/${var.kms_key_name}"
#}

resource "aws_efs_file_system" "efs" {
  performance_mode = var.efs_performance_mode
  encrypted        = var.encrypted
  kms_key_id       = var.encrypted ? var.kms_key_arn : null ##If encrypted is true it requires kms_key_id other wise the value set to null and on the run this get's ignored
  dynamic "lifecycle_policy" {
    for_each = var.transition_to_ia != null ? [var.transition_to_ia] : []
    content {
      transition_to_ia = lifecycle_policy.value
    }
  }
  dynamic "lifecycle_policy" {
    for_each = var.transition_to_ia != null ? [var.transition_to_ia] : []
    content {
      transition_to_primary_storage_class = "AFTER_1_ACCESS" ##Enabling Intelligent tiering
    }
  }
  throughput_mode                 = var.efs_throughput_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  tags = {
    Name = var.efs_name
    env  = var.env_name
  }
}

resource "aws_security_group" "efs-sg" {
  name        = "${var.efs_name}-sg"
  description = "${var.efs_name}-sg"
  vpc_id      = var.vpc_id
  ingress {
    protocol    = "tcp"
    to_port     = "2049"
    from_port   = "2049"
    cidr_blocks = [var.vpc_cidr] ##All workloads within this vpc range can access efs
  }
  egress {
    description = "All outbound enabled"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.efs_name}-sg"
    env  = var.env_name
  }
  lifecycle {
    create_before_destroy = true
  }
}

##Creating Mount targets for efs
resource "aws_efs_mount_target" "efs_mount_tg" {
  count           = length(var.efs_mount_targets_subnet_ids)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.efs_mount_targets_subnet_ids[count.index]
  security_groups = [aws_security_group.efs-sg.id]
}


