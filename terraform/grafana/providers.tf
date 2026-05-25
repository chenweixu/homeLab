# 配置 Terraform 和 Provider
terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 4.33.0"
    }
  }
}

provider "grafana" {
  url  = var.grafana_endpoint
  auth = var.api_token
}
