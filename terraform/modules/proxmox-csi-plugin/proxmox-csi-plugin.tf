
resource "proxmox_virtual_environment_role" "csi" {
  role_id = "CSI"
  privileges = [
    "VM.Audit",
    "VM.Config.Disk",
    "Datastore.Allocate",
    "Datastore.AllocateSpace",
    "Datastore.Audit"
  ]
}

resource "proxmox_virtual_environment_user" "kubernetes-csi" {
  user_id = var.user_id
  comment = "User for Proxmox CSI Plugin"
  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.csi.role_id
  }
}

resource "proxmox_user_token" "kubernetes-csi-token" {
  comment = "Token for Proxmox CSI Plugin"
  # expiration_date = "2033-01-01T22:00:00Z"
  token_name            = "csi"
  user_id               = proxmox_virtual_environment_user.kubernetes-csi.user_id
  privileges_separation = false
}

resource "vault_kv_secret_v2" "proxmox_csi_key" {
  mount     = var.vault_mount
  name      = var.vault_token_path
  data_json = jsonencode({
    token = proxmox_user_token.kubernetes-csi-token.value
  })
}


output "csi_token_name" {
  value = proxmox_user_token.kubernetes-csi-token.id
}

output "csi_token_value" {
  value     = proxmox_user_token.kubernetes-csi-token.value
  sensitive = true
}
