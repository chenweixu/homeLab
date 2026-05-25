

单个主机
```sh

data "local_file" "ssh_public_key" {
  filename = var.ssh_public_key_path
}

module "vm_web1" {
  source = "../modules/proxmox_vm"

  vm_name     =
  target_node = var.default_proxmox_node
  template_name = "template-ubuntu-2404-v1"
  ssh_public_key_ubuntu = data.local_file.ssh_public_key.content

  vm_name           = "web-server-01"
  cpu_core          = 2
  memory_size       = 4096
  system_disk_size  = 30

  ipv4_address = "192.168.5.41/24"
  ipv4_gateway = "192.168.5.254"
  vm_tags      = ["terraform", "ubuntu", "web"]

  # 按需添加数据盘
  additional_disks = [
    { interface = "scsi1", size = 20 }
  ]
}
```

多个实例
```sh
module "vm_k8s_nodes" {
  source = "../modules/proxmox_vm"

  for_each = var.servers

  target_node = each.value.target_node
  template_name = "template-ubuntu-2404-v2"

  ssh_public_key_ubuntu = data.local_file.ssh_public_key.content

  vm_name           = each.value.name
  cpu_core          = each.value.cpu
  memory_size       = each.value.ram
  system_disk_size  = each.value.disk

  ipv4_address = each.value.ip
  ipv4_gateway = var.net_work_gateway_address
  vm_tags      = ["terraform", "ubuntu", "k8s"]

}

```
