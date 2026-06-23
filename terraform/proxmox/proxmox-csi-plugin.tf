

module "proxmox-csi-plugin" {
  source               = "../modules/proxmox-csi-plugin"
  vault_mount          = "homelab"
  vault_token_path     = "infra/proxmox/csi-user"
  user_id              = "kubernetes-csi@pve"
  proxmox_endpoint     = data.vault_generic_secret.proxmox_endpoint.data["api_address"]
  proxmox_cluster_name = var.proxmox_cluster_name
}
