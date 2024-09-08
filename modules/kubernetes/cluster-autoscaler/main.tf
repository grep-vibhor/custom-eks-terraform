# Installing cluster autoscaler via EKS Blueprints - https://github.com/aws-ia/terraform-aws-eks-blueprints

# Example for cluster autoscaler k8s addon - https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/examples/complete-kubernetes-addons/main.tf#L248
module "kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"

  eks_cluster_id = var.cluster_id

  # Self-managed Add-ons
  enable_cluster_autoscaler = true
  cluster_autoscaler_helm_config = {
    # version   = "9.10.7"
    namespace = "kube-system"
    #   timeout    = "1200"
    #   lint       = "true"

    # This approach replaces all their defaults - https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/modules/kubernetes-addons/cluster-autoscaler/values.yaml
    values = [templatefile("${path.module}/helm_values/values.yaml", {
      image_tag      = var.image_tag,
      replicas       = var.replicas,
      aws_region     = var.region,
      eks_cluster_id = var.cluster_id,
    })]

    # This approach overrides select values
    #set = [
    #  {
    #    name  = "image.tag"
    #    value = var.image_tag
    #  }
    #]
  }
}
