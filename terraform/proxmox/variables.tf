
variable "vault_address" {
  type        = string
  description = "Vault address"
  default     = "https://localhost:8200"
}

variable "vault_role_id" {
  type      = string
  sensitive = true
}

variable "vault_secret_id" {
  type      = string
  sensitive = true
}


variable "vault_ssh_key_path" {
  type        = string
  description = "Vault KV v2 path for Proxmox SSH keys (contains private_key and public_key)"
  default     = ""
}

variable "vault_kubeconfig_path" {
  type        = string
  description = "Vault KV v2 path for kubeconfig (contains config key)"
  default     = "infra/kubernetes/config"
}

#===================================================================
variable "proxmox_cluster_name" {
  type      = string
  sensitive = true
  default   = ""
}

variable "default_proxmox_node" {
  type        = string
  default     = ""
  description = "default proxmox node"
}


variable "default_datastore_node10" {
  type        = string
  description = "node10 store disk id"
  default     = "local-lvm"
}

variable "image_url" {
  type        = string
  description = "download os image url"
  default     = ""
}


variable "servers" {
  description = "K8s nodes configuration"
  type = map(object({
    name        = string
    ip          = string
    cpu         = number
    ram         = number
    disk        = number
    target_node = string
  }))
  default = {}
}

variable "ssh_local_private_key_path" {
  type        = string
  description = "Local filesystem path to SSH private key, used in generated SSH config (not read by Terraform)"
  default     = ""
}

variable "net_work_gateway_address" {
  type        = string
  description = "IP of Proxmox server (mandatory)"
  default     = ""
}
