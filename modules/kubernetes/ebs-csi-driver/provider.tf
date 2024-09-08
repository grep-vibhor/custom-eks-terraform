provider "aws" {
  region = var.region
}

##############################
# The helm provider block establishes your identity to your Kubernetes cluster. 
# The host and the cluster_ca_certificate use your aws_eks_cluster state data source to construct a method for logging in to your cluster. 
# short-lived token to authenticate to your EKS cluster.
#########################################
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
