
terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "1.272.1"
    }
  }
}

provider "alicloud" {}
