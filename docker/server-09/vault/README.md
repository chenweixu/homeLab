
https://vault.chenwx.top

## 部署前准备
```sh
mkdir /home/wait/docker/vault/data
chown 100:100 /home/wait/docker/vault/data

docker compose up -d

# 使用 -e 覆盖环境变量, 避免客户端去读那个 config.hcl
docker exec -it \
  -e VAULT_ADDR="http://127.0.0.1:8200" \
  -e VAULT_CONFIG_PATH="" \
  vault vault operator init

```

Unseal 过程:
每次重启容器, Vault 都会处于 Sealed(封印)状态;
需要使用初始化时生成的 Keys 运行 vault operator unseal

```sh
# 解封命令(需要运行 3 次, 每次输入不同的 key)
docker exec -it -e VAULT_ADDR="http://127.0.0.1:8200" \
-e VAULT_CONFIG_PATH="" \
vault vault operator unseal

docker exec -it -e VAULT_ADDR="http://127.0.0.1:8200" \
-e VAULT_CONFIG_PATH="" \
vault vault status

```

**其它命令**
```sh
export VAULT_ADDR='https://vault.chenwx.top'
export VAULT_TOKEN=''

vault status

vault kv get pro/db/pg

wait@ub05:~$ vault secrets list
Path          Type         Accessor              Description
----          ----         --------              -----------
app2/         kv           kv_51e2eaea           n/a
cubbyhole/    cubbyhole    cubbyhole_812e8580    per-token private secret storage
identity/     identity     identity_5fc6b2a8     identity store
sys/          system       system_cca914e7       system endpoints used for control, policy and debugging

vault kv get app2/pro/db/pg
```


```sh
# 查看已经开启的认证方法
vault auth list
Path         Type        Accessor                  Description                Version
----         ----        --------                  -----------                -------
approle/     approle     auth_approle_f18cd096     n/a                        n/a
token/       token       auth_token_ecd6971e       token based credentials    n/a
userpass/    userpass    auth_userpass_42108dc7    n/a                        n/a

# 获取 token
vault write auth/userpass/users/user1 password=

vault list auth/userpass/users

vault login -method=userpass username=user1 password=foobar

```
