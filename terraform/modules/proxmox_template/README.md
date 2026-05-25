
创建一个薄模板

模板的任务只是: 下载镜像, 挂好磁盘, 把 agent 设为 enabled
不做系统的初始化内容
只是为了方便创建虚拟机时进行克隆


创建一个模板
```sh
data "local_file" "user_root_key" {
  filename = var.user_root_key
}
data "local_file" "user_ubuntu_key" {
  filename = "/home/wait/git/env/keys/cwx/cwx_id_ed25519.pub"
}

module "ubuntu_template_v1" {
  source = "../modules/proxmox_template"

  target_node   = "pve"
  template_name = "ubuntu-2404-template-v1"

  ssh_public_key_admin  = data.local_file.user_root_key.content
  ssh_public_key_ubuntu = data.local_file.user_ubuntu_key.content

  image_url = var.image_url

  iso_datastore_id = "local"
  vm_datastore_id  = "local-lvm"

  cpu_cores   = 2
  memory_size = 1024
  disk_size   = 15

  ipv4_address    = "192.168.5.40/24"
  ipv4_gateway_ip = "192.168.5.254"
  dns_address     = ["192.168.5.9", "8.8.8.8"]
  network_bridge  = "vmbr0"
  os_family       = "ubuntu"
}

output "template_ubuntu_template_v1_details" {
  description = "template 的具体信息"
  value = {
    id      = module.ubuntu_template_v1.template_id
    name    = module.ubuntu_template_v1.template_name
    node    = module.ubuntu_template_v1.template_node
    snippet = module.ubuntu_template_v1.template_snippet
  }
}
```
