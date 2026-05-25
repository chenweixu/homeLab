terraform {
  required_providers {

    vault = {
      source  = "hashicorp/vault"
      version = "5.8.0"
    }
  }

  backend "pg" {
    schema_name = "homeLab-vault"
  }
}

provider "vault" {
  address      = var.vault_address
  token        = var.vault_token
}
