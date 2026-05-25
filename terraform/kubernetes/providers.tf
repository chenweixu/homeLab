terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    # restapi = {
    #   source  = "Mastercard/restapi"
    #   version = "3.0.0"
    # }

  }
  backend "pg" {
    schema_name = "homeLab-kubernetes"
  }

}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
