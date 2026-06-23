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
    local = {
      source  = "hashicorp/local"
      version = "~>2.0"
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

# -------------------------

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

# -------------------------

provider "kubernetes" {
  # Use KUBE_CONFIG_PATH environment variables
  # Or in cluster service account
  # or ~/.kube/config
  config_path = pathexpand("~/.kube/config")
}

# -------------------------

data "vault_generic_secret" "proxmox_endpoint" {
  path = "homelab/infra/proxmox/local-cluster/endpoint"
}

ephemeral "vault_kv_secret_v2" "proxmox_auth" {
  mount = "homelab"
  name  = "infra/proxmox/local-cluster/auth"
}

# 使用 ephemeral 避免私钥落地
ephemeral "vault_kv_secret_v2" "ssh_private_keys" {
  mount = "homelab"
  name  = "infra/ssh-keys/cwx-key-private"
}

# 公钥可以落地
data "vault_generic_secret" "ssh_public_key" {
  path = "homelab/infra/ssh-keys/cwx-key-public"
}

# -------------------------

provider "proxmox" {
  #   endpoint  = data.vault_kv_secret_v2.proxmox_endpoint.data["api_address"]
  endpoint  = data.vault_generic_secret.proxmox_endpoint.data["api_address"]
  api_token = "${ephemeral.vault_kv_secret_v2.proxmox_auth.data["api_id"]}=${ephemeral.vault_kv_secret_v2.proxmox_auth.data["api_secret"]}"
  insecure  = true
  ssh {
    agent    = true
    username = "root"
    # 直接使用 Vault 中的私钥内容，不依赖本地文件
    private_key = ephemeral.vault_kv_secret_v2.ssh_private_keys.data["key"]

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
