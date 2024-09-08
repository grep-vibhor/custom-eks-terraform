include "root" {
  path = find_in_parent_folders()
}

locals {
  global_var = read_terragrunt_config(find_in_parent_folders("global.hcl"))
}

terraform {
  source = "${local.global_var.inputs.module_source_path}/aws/iam/iam-role"
}

inputs = {
  name        = "${local.global_var.inputs.org_name}-${local.global_var.inputs.env}-eks-cluster-worker-role"
  description = "${local.global_var.inputs.org_name}-${local.global_var.inputs.env}-eks-cluster-worker-role"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  environment = local.global_var.inputs.env
  region       = local.global_var.inputs.region
  tags = {
    env = local.global_var.inputs.env
  }
  inline_policy = [
    {
      "name": "eks-resources-access",
      "policy": jsonencode({
          "Version": "2012-10-17",
          "Statement": [
              ############ Permissions for using Encrypted EBS volumes
              {
                  "Effect": "Allow",
                  "Action": [
                    "kms:Encrypt",
                    "kms:Decrypt",
                    "kms:ReEncrypt*",
                    "kms:GenerateDataKey*",
                    "kms:DescribeKey",
                  ],
                  "Resource": [
                      "*"
                  ]
              },
              ################################
              ############## Permissions Required by prometheus exporters
              {
                "Effect": "Allow",
                "Action": "ce:GetCostAndUsage",
                "Resource": "*"
              },
              {
                "Effect": "Allow",
                "Action": "cloudfront:ListDistributions",
                "Resource": "*"
              },
              {
                "Effect": "Allow",
                "Action": [
                  "acm:ListCertificates"
                ],
                "Resource": "*"
              },
              {
                "Effect": "Allow",
                "Action": [
                  "rds:DescribeDBInstances",
                  "logs:FilterLogEvents",
                  "cloudwatch:GetMetricStatistics",
                  "ec2:RevokeSecurityGroupIngress",
                  "ec2:AuthorizeSecurityGroupIngress"
                ],
                "Resource": "*"
              }
              #############################
          ]
      })
    }
  ]  
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}
