
# 开启 userpass 认证方法
resource "vault_auth_backend" "userpass" {
  type = "userpass"
  path = "userpass"
}

resource "vault_generic_endpoint" "admin" {
  depends_on = [vault_auth_backend.userpass]

  path      = "auth/userpass/users/admin"

  # 这里只写密码; 如果 var.admin_password 没传, 这里会报错, 强制在第一次部署时必须提供密码;
  data_json = jsonencode({
    password = var.admin_password
  })

  lifecycle {
    # 核心: 一旦创建成功, 后续不再比对和更新这个资源, 即密码
    ignore_changes = [data_json]
  }
}

# 声明式管理权限, 即身份和策略
resource "vault_identity_entity" "admin_identity" {
  name     = "admin-user"
  policies = ["admin", "default"]
}

# 绑定用户和身份
resource "vault_identity_entity_alias" "admin" {
  name           = "admin"  # 对应 userpass 里的用户名
  mount_accessor = vault_auth_backend.userpass.accessor
  canonical_id   = vault_identity_entity.admin_identity.id
}
