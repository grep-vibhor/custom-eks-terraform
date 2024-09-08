resource "helm_release" "argocd_helm_release" {
  name       = "argo-cd"
  chart      = "argo-cd"
  repository = var.argocd_helm_repo
  version    = var.argocd_helm_chart_version
  namespace  = var.namespace
  timeout    = var.timeout
  create_namespace = var.create_namespace
  values = [templatefile("${path.module}/k8s_values/argocd-values.yaml", {
    argocd_dns_name = var.argocd_host,
    argocd_full_domain_path = var.argocd_full_domain_path
    argocd_dns_cert_arn = var.acm_certificate_arn
    node_selector_key = var.node_selector_key
    node_selector_value = var.node_selector_value
    tolerations_key = var.tolerations_key
    tolerations_value = var.tolerations_value
    load_balancer_identifier = var.load_balancer_identifier
    load_balancer_subnets = var.load_balancer_subnets
    load_balancer_security_groups = var.load_balancer_security_groups
    controller_replicas = var.controller_replicas
    server_replicas = var.server_replicas
    repoServer_replicas = var.repoServer_replicas
  })]
}
