terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~>0.100.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "5.8.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>3.0"
    }
  }

  backend "s3" {
    bucket = "terraform"
    key    = "homeLab/proxmox/terraform.tfstate"
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

provider "kubernetes" {
  config_path = "~/.kube/config"
}


ephemeral "vault_kv_secret_v2" "pve_creds" {
  mount = "homelab"
  name  = "infra/proxmox"
}


provider "proxmox" {
  endpoint  = ephemeral.vault_kv_secret_v2.pve_creds.data["api_address"]
  api_token = "${ephemeral.vault_kv_secret_v2.pve_creds.data["api_id"]}=${ephemeral.vault_kv_secret_v2.pve_creds.data["api_secret"]}"
  insecure  = true
  ssh {
    agent       = true
    username    = "root"
    private_key = file(var.proxmox_ssh_key_path)

    node {
      name    = "pve-home"
      address = "192.168.5.9"
    }

    node {
      name    = "pve"
      address = "192.168.5.10"
      port    = 22
    }
  }
}
