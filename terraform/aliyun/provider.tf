
terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "1.272.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "5.8.0"
    }
  }

  backend "s3" {
    bucket = "terraform"
    key    = "homeLab/aliyun/terraform.tfstate"
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

provider "alicloud" {}


provider "vault" {
  address = var.vault_address
  auth_login {
    path = "auth/approle/login"
    parameters = {
      role_id   = var.vault_role_id
      secret_id = var.vault_secret_id
    }
  }
}
