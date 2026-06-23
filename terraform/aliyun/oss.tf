
# 获取当前账号信息
data "alicloud_account" "current" {}

# 从 Vault 获取 aliyun 相关配置
data "vault_kv_secret_v2" "aliyun_creds" {
  mount = "homelab"
  name  = "infra/aliyun"
}

# 输出账号 ID, 方便调试
output "current_account_id" {
  value = data.alicloud_account.current.id
}


resource "alicloud_oss_bucket" "bucket" {
  bucket = data.vault_kv_secret_v2.aliyun_creds.data["oss_bucket_name"]

  # 还有文件时, 不能删除bucket
  force_destroy = false

  # 不允许同一个 Action 被多条生命周期规则匹配
  lifecycle_rule_allow_same_action_overlap = false
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "oss:GetObject",
          "oss:GetObjectAcl",
          "oss:RestoreObject",
          "oss:GetVodPlaylist",
          "oss:GetObjectVersion",
          "oss:GetObjectVersionAcl",
          "oss:RestoreObjectVersion",
        ]
        Condition = {
          Bool = { "acs:SecureTransport" = ["true"] }
        }
        Effect    = "Allow"
        Principal = ["*"]
        Resource = [
          "acs:oss:*:${data.alicloud_account.current.id}:${data.vault_kv_secret_v2.aliyun_creds.data["oss_bucket_name"]}/public/*",
        ]
      },
    ]
    Version = "1"
  })
  tags = {}

}

resource "alicloud_oss_bucket_acl" "bucket-acl" {
  bucket = alicloud_oss_bucket.bucket.bucket
  acl    = "private"
}
