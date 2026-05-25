

variable "user_id" {
  type      = string
  sensitive = true
  default   = ""
}

variable "vault_mount" {
  description = "Vault KV mount path"
  type        = string
  default     = ""
}

variable "vault_token_path" {
  type      = string
  sensitive = true
  default   = ""
}

variable "proxmox_endpoint" {
  type        = string
  description = "IP of Proxmox server (mandatory)"
  default     = ""
}

variable "proxmox_cluster_name" {
  type      = string
  sensitive = true
  description = "pve cluster name"
  default   = ""
}
