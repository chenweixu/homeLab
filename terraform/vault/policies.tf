
# 给 terraform 角色的权限
resource "vault_policy" "terraform" {
  name   = "terraform"
  policy = file("policies/terraform.hcl")
}

# 创建权限策略
resource "vault_policy" "admin" {
  name   = "admin"
  policy = file("policies/admin.hcl")
}

resource "vault_policy" "kvuser" {
  name   = "kvuser"
  policy = file("policies/kvuser.hcl")
}

# # 声明 readonly 策略
# resource "vault_policy" "readonly" {
#   name   = "admin-readonly"
#   policy = file("policies/readonly-policy.hcl")
# }
