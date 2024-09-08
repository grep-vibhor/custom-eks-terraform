# Installing cluster autoscaler via EKS Blueprints - https://github.com/aws-ia/terraform-aws-eks-blueprints

# Example for cluster autoscaler k8s addon - https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/examples/complete-kubernetes-addons/main.tf#L248
module "kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"

  eks_cluster_id = var.cluster_id

  # Self-managed Add-ons
  enable_aws_efs_csi_driver = true

  # https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/modules/kubernetes-addons/variables.tf#L446
  # Optional
  aws_efs_csi_driver_helm_config = {
    version   = "2.2.6"
    namespace = "kube-system"
    values    = [templatefile("${path.module}/helm_values/values.yaml", {})]
  }
}
