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

  backend "pg" {
    schema_name = "homeLab-proxmox"
  }

}

provider "vault" {
  address      = var.vault_address
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
  #   endpoint  = var.proxmox_endpoint

  endpoint = ephemeral.vault_kv_secret_v2.pve_creds.data["api_address"]

  # api_token = var.proxmox_api_token
  api_token = "${ephemeral.vault_kv_secret_v2.pve_creds.data["api_id"]}=${ephemeral.vault_kv_secret_v2.pve_creds.data["api_secret"]}"

  # 是否使用自签名证书
  insecure = true

  # 某些操作需要 SSH, 可以配置 SSH 连接
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
