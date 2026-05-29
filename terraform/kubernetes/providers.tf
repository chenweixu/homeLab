terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    # restapi = {
    #   source  = "Mastercard/restapi"
    #   version = "3.0.0"
    # }

  }
  backend "s3" {
    bucket = "terraform"
    key    = "homeLab/kubernetes/terraform.tfstate"
    region = "us-east-1"
    endpoints = {
      s3 = "https://minio.chenwx.top"
    }
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
    use_lockfile                = true
    encrypt                     = false
  }

}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
