
# 定义 KV V2 存储引擎
resource "vault_mount" "homelab" {
  path        = "homelab"
  type        = "kv"  # 5.x 版本的 provider 通常直接支持 kv-v2 类型

  options     = {
    version = "2"
  }

  description = "HomeLab 环境的 KV 存储(由 Terraform 管理)"

}
