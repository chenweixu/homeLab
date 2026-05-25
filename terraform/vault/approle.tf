
# 开启 AppRole 认证
resource "vault_auth_backend" "approle" {
  type = "approle"
}

# 角色1: terraform-role
resource "vault_approle_auth_backend_role" "terraform_role" {
  backend        = vault_auth_backend.approle.path
  role_name      = "terraform-role"

  # 对应手动执行的参数
  secret_id_ttl  = 0
  token_num_uses = 0
  token_ttl      = 3600  # 单位s
  token_max_ttl  = 10800

  # 绑定上面定义的策略名
  token_policies = [vault_policy.terraform.name]
}

# 角色2: 并绑定 kvuser 策略
resource "vault_approle_auth_backend_role" "app1" {
  depends_on = [vault_auth_backend.approle]

  backend        = vault_auth_backend.approle.path
  role_name      = "homelab-app1"
  token_policies = [vault_policy.kvuser.name] # 引用策略名
}


output "terraform_role_id" {
    value = vault_approle_auth_backend_role.terraform_role.role_id
}

output "app1_role_id" {
    value = vault_approle_auth_backend_role.app1.role_id
}
