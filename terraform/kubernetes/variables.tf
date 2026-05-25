
variable "sealed_secrets_config" {
  description = "Sealed-secrets configuration"
  type = object({
    certificate_path     = string
    certificate_key_path = string
  })
}
