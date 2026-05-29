

module "proxmox-csi-plugin" {
  source               = "../modules/proxmox-csi-plugin"
  vault_mount          = "homelab"
  vault_token_path     = "infra/proxmox/csi-user"
  user_id              = "kubernetes-csi@pve"
  proxmox_endpoint     = var.proxmox_endpoint
  proxmox_cluster_name = var.proxmox_cluster_name
}
