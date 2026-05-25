
# 初始化插件
packer init .

# 检查配置是否正确
packer validate .

# 开始构建
packer build ubuntu-2404.pkr.hcl


在 Terraform 中引用新模板
```
resource "proxmox_virtual_environment_vm" "k8s_node" {
  name      = "k8s-master-01"
  template_file_id = "local:vztmpl/template-ubuntu-2404" # 引用 Packer 生成的 ID

  initialization {
    # 此时你只需要声明 IP，主机名会因为镜像干净而自动同步
    ip_config {
      ipv4 {
        address = "192.168.5.50/24"
        gateway = "192.168.5.254"
      }
    }
  }
}

```
