terraform {
  required_providers {

    vault = {
      source  = "hashicorp/vault"
      version = "5.8.0"
    }
  }

  backend "s3" {
    bucket = "terraform"
    key    = "homeLab/vault/terraform.tfstate"
    region = "us-east-1"
    endpoints = {
      s3 = "https://minio.chenwx.top"
    }
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    use_path_style              = true
    use_lockfile                = true
    encrypt                     = false
  }

}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}
