
# KV v2 写入需要同时有 data 和 metadata 的写权限
# 多层 * 覆盖: homelab/<key>, homelab/<dir>/<key>, homelab/<dir>/<dir>/<key>

path "homelab/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "homelab/data/*/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "homelab/data/*/*/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "homelab/metadata/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "homelab/metadata/*/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
path "homelab/metadata/*/*/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# 允许浏览顶层目录
path "homelab/metadata/" {
  capabilities = ["list"]
}

# 允许创建子token
path "auth/token/create" {
  capabilities = ["update"]
}
