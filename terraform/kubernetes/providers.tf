terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "5.8.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~>2.0"
    }
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

# ── 从 Vault 读取 kubeconfig ──
ephemeral "vault_kv_secret_v2" "kubeconfig" {
  mount = "homelab"
  name  = "infra/kubernetes/config"
}

resource "local_file" "kubeconfig" {
  filename        = "${path.module}/.kubeconfig"
  file_permission = "0600"
  content         = ephemeral.vault_kv_secret_v2.kubeconfig.data["config"]
}

provider "kubernetes" {
  config_path = local_file.kubeconfig.filename
}
