# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket  = "fivexl-terraform-backend"
    encrypt = true
    key     = "dev/kms/terraform.tfstate"
    region  = "eu-west-1"
  }
}
