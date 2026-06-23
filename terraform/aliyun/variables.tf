
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

variable "cert_ram_user_name" {
  description = "cert-manager 专用 RAM 用户名"
  type        = string
  default     = "cert-manager-dns"
}

variable "general_instance_zone" {
  description = "server zone"
  type        = string
  default     = ""
}
