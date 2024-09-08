# Installing cluster autoscaler via EKS Blueprints - https://github.com/aws-ia/terraform-aws-eks-blueprints

# Example for cluster autoscaler k8s addon - https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/examples/complete-kubernetes-addons/main.tf#L248
module "kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"

  eks_cluster_id = var.cluster_id

  # Self-managed Add-ons
  enable_amazon_eks_vpc_cni = true
  
  amazon_eks_vpc_cni_config = var.amazon_eks_vpc_cni_config
}
