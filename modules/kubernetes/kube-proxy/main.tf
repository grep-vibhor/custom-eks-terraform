# Installing cluster autoscaler via EKS Blueprints - https://github.com/aws-ia/terraform-aws-eks-blueprints

# Example for cluster autoscaler k8s addon - https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/examples/complete-kubernetes-addons/main.tf#L248
module "kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"

  eks_cluster_id = var.cluster_id

  # Self-managed Add-ons
  enable_amazon_eks_kube_proxy = true

  # https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/6f571f2dbe3e5243681562f4ac9964af9e391c3c/modules/kubernetes-addons/main.tf#L44
  # Optional
  amazon_eks_kube_proxy_config = var.amazon_eks_kube_proxy_config
}
