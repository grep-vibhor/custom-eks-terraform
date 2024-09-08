# EKS Deployment

## Prerequisites

* Ensure to set aws creds in your environment
* Make necessary changes in `inrfa_resoures/global.hcl` file like values for region, account-id, vpc CIDRs etc.

## Deployment

## Step 1. Uptil EKS with Node Groups:
```bash
cd infra_resources
```

```bash
terragrunt run-all plan --terragrunt-non-interactive --terragrunt-include-dir  ./acm --terragrunt-non-interactive --terragrunt-include-dir  ./vpc --terragrunt-include-dir  ./eks-worker-node-role  --terragrunt-include-dir ./internal_alb_security_group --terragrunt-include-dir  ./kms  --terragrunt-include-dir  ./eks --terragrunt-include-dir  ./ebs-csi-driver-role --terragrunt-include-dir ./nodegroups/devops/
```



## Step 2. At this point Create Peering connnection for admin-vpc-eks-vpc

```bash
cd infra_resources
```

```
--  1st plan group
Group 1
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/acm
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/eks-worker-node-role
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/kms

Group 2
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/eks

Group 3
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/ebs-csi-driver-role
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/nodegroups/devops

```

```bash
cd infra_resources
```


```bash
terragrunt run-all apply --terragrunt-non-interactive --terragrunt-include-dir  ./acm --terragrunt-include-dir   ./eks-worker-node-role --terragrunt-include-dir ./internal_alb_security_group --terragrunt-include-dir  ./kms  --terragrunt-include-dir  ./eks --terragrunt-include-dir  ./ebs-csi-driver-role --terragrunt-include-dir ./nodegroups/devops/
```

###### Once ACM is created, add its CNAME to route53 for vaerification


###### Optional:

```bash
cd infra_resources
```

```bash
aws eks update-kubeconfig --name publitas-dev-cluster --region $AWS_REGION
kubectl config get-contexts
kubectl config current-context
kubectl cluster-info
```

## Step 3. Deploy APPS except ARGOCD because argocd requires other apps especially cluster autoscaler 

```bash
cd infra_resources
```

```bash
terragrunt  run-all apply --terragrunt-include-dir ./kubernetes/aws-load-balancer-controller/ --terragrunt-include-dir ./kubernetes/cluster-autoscaler/ --terragrunt-include-dir ./kubernetes/ebs_csi_driver/ --terragrunt-include-dir ./kubernetes/efs-csi-driver/ --terragrunt-include-dir ./kubernetes/kube-proxy/ --terragrunt-include-dir ./kubernetes/vpc-cni/

terragrunt  run-all apply --terragrunt-exclude-dir  ./argocd

# Results in folliwng:-

Group 1
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/acm
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/eks-worker-node-role
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/kms

Group 2
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/eks

Group 3
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/ebs-csi-driver-role
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/kubernetes/aws-load-balancer-controller
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/kubernetes/efs-csi-driver
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/nodegroups/devops

Group 4
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/kubernetes/cluster-autoscaler
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/kubernetes/ebs_csi_driver
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/kubernetes/kube-proxy
- Module /Users/vibhorjain/Documents/rough/k8s/terragrunt/kubernetes/vpc-cni
```


## Step 4. Update AWS LOAD BALANCER IRSA role with addtags permission

## Step 5. For argocd-

```bash
cd infra_resources
```


```bash
   terragrunt run-all  plan  --terragrunt-non-interactive --terragrunt-exclude-dir ./kubernetes/aws-load-balancer-controller
   terragrunt run-all  apply  --terragrunt-non-interactive --terragrunt-exclude-dir ./kubernetes/aws-load-balancer-controller
```

## Step 6. Create monitoring namespace
## Step 7. add LB dns cname to point to your domain
## Step 8. create peering between EKS VPC and prod,int VPCs
## Step 9. allow netdata scrape (19999) port on prod and int SGs  from EKS VPC CIDR
## Step 10. allow puma scrape (8080) port on prod and int SGs  from EKS VPC CIDR

## Step 11. create exporters
## Step 12. create prometheus and grafana helm chart
## Step 13. once prometheus ingress is created add extraPath for SSL (copy from grafana ingress)





-----------  Destroy------------------------

```
terragrunt run-all destroy  --terragrunt-non-interactive --terragrunt-include-dir ./argocd/
```
```
terragrunt  run-all destroy --terragrunt-include-dir ./kubernetes/aws-load-balancer-controller/ --terragrunt-include-dir ./kubernetes/cluster-autoscaler/ --terragrunt-include-dir ./kubernetes/ebs_csi_driver/ --terragrunt-include-dir ./kubernetes/efs-csi-driver/ --terragrunt-include-dir ./kubernetes/kube-proxy/ --terragrunt-include-dir ./kubernetes/vpc-cni/ --terragrunt-exclude-dir ./kms
```
destroy chain:

```
Group 1
- Module /Users/vibhorjain/Documents/terraform/aws/eks_infra/kubernetes/aws-load-balancer-controller
- Module /Users/vibhorjain/Documents/terraform/aws/eks_infra/kubernetes/cluster-autoscaler
- Module /Users/vibhorjain/Documents/terraform/aws/eks_infra/kubernetes/ebs_csi_driver
- Module /Users/vibhorjain/Documents/terraform/aws/eks_infra/kubernetes/efs-csi-driver
- Module /Users/vibhorjain/Documents/terraform/aws/eks_infra/kubernetes/kube-proxy
- Module /Users/vibhorjain/Documents/terraform/aws/eks_infra/kubernetes/vpc-cni

Group 2
- Module /Users/vibhorjain/Documents/terraform/aws/eks_infra/ebs-csi-driver-role
- Module /Users/vibhorjain/Documents/terraform/aws/eks_infra/nodegroups/devops

Group 3
- Module /Users/vibhorjain/Documents/terraform/aws/eks_infra/eks

Group 4
- Module /Users/vibhorjain/Documents/terraform/aws/eks_infra/eks-worker-node-role
```
```
terragrunt destroy --terragrunt-non-interactive -auto-approve
```


* Check LB is deleted or not
* Check if there are any free Volumes
* MANUALLY DELETE CNAMES you created for ACM certificate
* Search for Security Grps by eks name - if some exist - delete it


## Troubleshooting steps

1. Whenever a nodegroup is added to nodegroups folder, add its dependency like devops NG dependency in code

2. In modules directory, inside Kubernetes modules we need to hardcode module path for cluster autoscaler, lb controller csi drivers

3. if you get error while creating EKS that localhost not reachable -
```bash
terraform state rm module.eks.kubernetes_config_map.aws_auth
```



