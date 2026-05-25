variable "grafana_endpoint" {
  type        = string
  description = "grafana server endpoint"
  default     = ""
}

variable "api_token" {
  type      = string
  sensitive = true
  default   = ""
}

variable "prometheus_url" {type = string}
variable "tempo_url" {type = string}
variable "jaeger_url" {type = string}
variable "loki_url" {type = string}
