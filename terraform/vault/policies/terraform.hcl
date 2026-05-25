
# 允许读取机密数据(针对 KV-V2)
# 注意: 对于 KV-V2 引擎, API 路径中必须包含 data/
path "homelab/data/infra/*" {
  capabilities = ["read", "list", "create", "update", "delete"]
}

# 允许操作 metadata 路径(版本元数据)
path "homelab/metadata/infra/*" {
  capabilities = ["read", "list", "create", "update", "delete"]
}


# 允许创建子 token
path "auth/token/create" {
  capabilities = ["update"]
}
