inputs = {
  account_id = "711387122494"
  region = "eu-west-1"
  vpc_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  org_name = "fivexl"
  argocd_host = "apps.k8s.fivexl.com"
  argocd_full_domain_path = "https://apps.k8s.fivexl.com/argocd"
  argocd_helm_repo = "https://charts.bitnami.com/bitnami"
  argocd_helm_chart_version = "4.7.18"
  module_source_path = "/Users/vibhor/Documents/rough/fivexl/modules"
  eks_blue_prints_module_path = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.32.1"
  eks_managed_node_group_module_path = "github.com/terraform-aws-modules/terraform-aws-eks///modules/eks-managed-node-group?ref=v19.15.4"
  eks_add_ons_module_path = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"

  aws_ebs_csi_driver_helm_repo = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver/"
  aws_ebs_csi_driver_helm_chart_version = "2.9.0"
  vpn_cidr_source = "192.168.200.0/28"
  vpn_gw_source = "54.73.234.31/32"
  csi_file_system = "xfs"
  # The nodes can either be in Public Subnet or Private Subnet
  # If Public:
  # Ensure that nodes deployed in public subnets are assigned a public IP address.
  # If the public subnet is not set to automatically assign public IP addresses to instances deployed to it, then we recommend enabling that setting.
  # If Private:
  # then the subnet must have a route to a NAT gateway that has a public IP address assigned to it.

  ## Required for argocd
  ## chartmuseum_username = ""
  ## chartmuseum_password = get_env("TF_VAR_chartmuseum_password", "")
  ##

  env        = "dev"
  tags       = {
     env     = "dev",
     ManagedBy = "terragrunt"
  }

  eks_version = "1.27"
  eks_auth_map_users = [
    {
        userarn  = "arn:aws:iam::711387122494:user/vibhor",
        username = "vibhor",
        groups   = ["system:masters"]
    },
  ]
  eks_auth_map_roles = []
}





