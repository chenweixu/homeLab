
这个任务需要高权限的 token

新窗口获取 terraform_role 的 role-id/Secret ID
```sh
vault read auth/approle/role/terraform-role/role-id
vault write -f auth/approle/role/terraform-role/secret-id
```

新创建写入基础配置信息

```sh
vault secrets list

# set pve token and addr
vault kv put homelab/infra/proxmox \
    api_address='https://192.168.5.9:8006' \
    api_id='-----' \
    api_secret="-----"

vault kv get homelab/infra/proxmox

```

```sh
# 已经开启 approle 时的导入
terraform import vault_auth_backend.approle approle

# 获取 role-id
vault read auth/approle/role/homelab-app1/role-id


# 生成 Secret ID
vault write -f auth/approle/role/homelab-app1/secret-id
```

```sh
vault secrets enable -path=homelab kv-v2
```

## terraform-role

1. 编写 Policy(策略)
2. 绑定到 Auth Method(认证方式)
3. 生成 Token

```sh
# 创建策略
vault policy write admin-readonly admin-readonly-policy.hcl

# 方法1: 生成长时间的 Token
# 生成一个 30 天有效, 绑定 admin-readonly 策略的 Token
vault token create -policy="admin-readonly" -period="720h"


# 方法2: 创建 AppRole 类似于云的 RAM 角色:
# 开启 AppRole 认证(如果没开)
vault auth enable approle

# 创建角色并绑定策略 - auth/approle/role/terraform-role
vault write auth/approle/role/terraform-role \
    secret_id_ttl=0 \
    token_num_uses=0 \
    token_ttl=1h \
    token_max_ttl=3h \
    token_policies="admin-readonly"

```

临时方法: 通过 role_id 和 secret_id 获取一个 token
```sh
vault write auth/approle/login \
    role_id="ae7830a4-ee10-3e84-xxxx-770b286bxxxx" \
    secret_id="f8268b33-6b96-d08f-xxxx-0c959dxxxx"
```
