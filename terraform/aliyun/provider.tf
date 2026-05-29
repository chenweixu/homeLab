
terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "1.272.1"
    }
  }

  backend "s3" {
    bucket = "terraform"
    key    = "homeLab/aliyun/terraform.tfstate"
    region = "us-east-1"
    endpoints = {
      s3 = "https://minio.chenwx.top"
    }
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
    use_lockfile                = true
    encrypt                     = false
  }

}

provider "alicloud" {}
