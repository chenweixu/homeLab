
## 用途
1. 用于独立创建一个实例的的参考
2. 用于关联集群中已经存在的模板


## 导入模板

```
resource "proxmox_virtual_environment_vm" "ubuntu-2404-v1" {
    name = "template-ubuntu-2404-v1"
    node_name = "pve"
    vm_id     = 9000
}

```

在root模块定义资源
```
# 根模块的 main.tf
module "ubuntu_template" {
  source = "./modules/proxmox_template_ubuntu"
  # ... 其他变量
}
```

在root模块导入
```sh
terraform import \
  module.ubuntu_template.proxmox_virtual_environment_vm.ubuntu-2404-v1 \
  pve/9000

# 查看参数 - 以便补全配置 - 可选
terraform show -json

# 刷新云上配置到本地
terraform refresh
```
