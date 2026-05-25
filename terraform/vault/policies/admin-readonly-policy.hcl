# 允许读取机密数据(针对 KV-V2)
# 注意: 对于 KV-V2 引擎, API 路径中必须包含 data/
path "homelab/data/infra/*" {
  capabilities = ["read", "list"]
}

# 允许读取机密数据的元数据(可选, 方便 Web UI 查看)
path "homelab/metadata/infra/*" {
  capabilities = ["read", "list"]
}

# 允许创建子token
path "auth/token/create" {
  capabilities = ["update"]
}
