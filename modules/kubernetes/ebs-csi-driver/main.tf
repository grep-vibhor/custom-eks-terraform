resource "helm_release" "ebs-csi-driver" {
  name       = "aws-ebs-csi-driver"
  repository = var.aws_ebs_csi_driver_helm_repo
  chart      = "aws-ebs-csi-driver"
  namespace  = "kube-system"
  version    = var.aws_ebs_csi_driver_helm_chart_version
  set {
    name  = "controller.serviceAccount.create"
    value = "true"
  }
  set {
    name  = "node.serviceAccount.create"
    value = "true"
  }
  set {
    name  = "controller.k8sTagClusterId"
    value = var.eks_cluster_id
  }
  set {
    name  = "controller.extraVolumeTags.env"
    value = var.env_name
  }
  set {
    name  = "node.tolerateAllTaints"
    value = "true"
  }
  values = [templatefile("${path.module}/k8s_values/values.yaml", {
        ebs_role_arn = var.ebs_role_arn,
        kms_key_arn  = var.ebs_kms_key_arn
        csi_file_system = var.csi_file_system
  })]
}

