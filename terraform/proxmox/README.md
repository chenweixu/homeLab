
## init

1. 在 vault 时使用超管的 key
2. 在 proxmox 使用 terraform-role 的 role-id 和 secret-id

因为相关密钥信息已经初始化到 vault 中, 所以下面部分不用执行


初始化资源
```sh
# 因为当前 pg 的密钥已经放置到了 vault
export PGURL=$(vault kv get -field=conn_str homelab/infra/postgres/tf)

# 切换数据库源之后需要更新, 已经将该连接字符串持久化到了状态文件, 后续不用再处理
terraform init -reconfigure -backend-config="conn_str=$PGURL"

# 新版本采用单的状态文件指定
terraform init -backend-config=backend.hcl
```


## 导入资源
```sh
terraform init

import {
  to = proxmox_virtual_environment_vm.v253
  id = "pve/200"
}

# 生成指定的资源配置文件 tf
terraform plan -generate-config-out=generated_resources.tf

# 将真实资源关联到状态文件 - 即写入状态文件
terraform import proxmox_virtual_environment_vm.v253 "pve/200"

# 验证 - 此时应该是 No changes
terraform plan

terraform state list

terraform apply


# 修改资源名称
terraform state mv proxmox_virtual_environment_vm.v253 proxmox_virtual_environment_vm.vm_models_200
```

```sh
# 单独处理模板
terraform apply -target="module.ubuntu_template_v1"
```


快速删除资源
```sh
# 先生成一个跳过刷新的计划
terraform plan -destroy -refresh=false -out=destroy.tfplan

# 执行这个计划
terraform apply "destroy.tfplan"


方法2: 删除状态后, 手动从 pve 删除资源
terraform state rm proxmox_virtual_environment_vm.vm-80
```


## 镜像地址

Ubuntu 24.04 官方 Cloud 镜像地址
```https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img```

本地镜像路径
```http://files.services.wait/soft/noble-server-cloudimg-amd64.img```



## proxmox-csi-plugin
获取 token 值
```sh
terraform output -json csi_token_value

```

校验
```sh
kubectl -n csi-proxmox get secret proxmox-csi-plugin -o jsonpath='{.data.config\.yaml}' | base64 -d

```
