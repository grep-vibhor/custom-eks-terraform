remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    region         = "eu-west-1"
    bucket         = "fivexl-terraform-backend"
    key            = "dev/${path_relative_to_include()}/terraform.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}
