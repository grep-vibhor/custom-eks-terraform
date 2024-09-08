# Installing cluster autoscaler via EKS Blueprints - https://github.com/aws-ia/terraform-aws-eks-blueprints

# Example for cluster autoscaler k8s addon - https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/examples/complete-kubernetes-addons/main.tf#L248
module "kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"

  eks_cluster_id = var.cluster_id

  # Self-managed Add-ons
  enable_aws_load_balancer_controller = true
  aws_load_balancer_controller_helm_config = {
    # version   = "9.10.7"
    namespace = "kube-system"
    #   timeout    = "1200"
    #   lint       = "true"

    # This approach replaces all their defaults - https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/modules/kubernetes-addons/cluster-autoscaler/values.yaml
    values = [templatefile("${path.module}/helm_values/values.yaml", {
      repository     = var.image_repository,
      aws_region     = var.region,
      eks_cluster_id = var.cluster_id,
      enableBackendSecurityGroup = var.enableBackendSecurityGroup
    })]
  }
}
