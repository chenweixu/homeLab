
variable "vault_address" {
  type        = string
  description = "Vault address"
  default     = "https://localhost:8200"
}

variable "postgres_dsn" {
  type        = string
  description = "postgres dsn"
  default     = ""
}

variable "proxmox_endpoint" {
  type        = string
  description = "IP of Proxmox server (mandatory)"
  default     = ""
}

variable "proxmox_cluster_name" {
  type      = string
  sensitive = true
  default   = ""
}

variable "proxmox_ssh_key_path" {
  type        = string
  description = "Proxmox server ssh key"
  default     = ""
}


#===================================================================

variable "proxmox_api_token" {
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

variable "vault_role_id" {
  type      = string
  sensitive = true
}

variable "vault_secret_id" {
  type      = string
  sensitive = true
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

variable "ssh_public_key_path" {
  type        = string
  description = "IP of Proxmox server (mandatory)"
  default     = ""
}

variable "net_work_gateway_address" {
  type        = string
  description = "IP of Proxmox server (mandatory)"
  default     = "192.168.5.254"
}
