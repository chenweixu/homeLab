
variable "oss_bucket_name" {
  description = "oss bucket name"
  type        = string
  default     = ""
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
