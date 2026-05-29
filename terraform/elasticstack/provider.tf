
# 配置 Terraform 和 Provider
terraform {
  required_providers {
    elasticstack = {
      source  = "elastic/elasticstack"
      version = "0.14"
    }
  }
}

provider "elasticstack" {
  elasticsearch {
    endpoints = [var.es_endpoints, ]
  }
}
