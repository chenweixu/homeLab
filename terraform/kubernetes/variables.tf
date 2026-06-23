
variable "vault_address" {
  type        = string
  description = "Vault server address"
  default     = "https://vault.chenwx.top"
}

variable "vault_role_id" {
  type      = string
  sensitive = true
}

variable "vault_secret_id" {
  type      = string
  sensitive = true
}

variable "sealed_secrets_config" {
  description = "Sealed-secrets configuration"
  type = object({
    certificate_path     = string
    certificate_key_path = string
  })
}
