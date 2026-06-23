
# SSH 公钥从 Vault 读取，不再依赖本地文件
module "vm_k8s_nodes" {
  source = "../modules/proxmox_vm"

  for_each = var.servers

  target_node   = each.value.target_node
  template_name = "template-ubuntu-2404-v2"

  ssh_public_key_ubuntu = data.vault_generic_secret.ssh_public_key.data["key"]

  vm_name          = each.value.name
  cpu_core         = each.value.cpu
  memory_size      = each.value.ram
  system_disk_size = each.value.disk

  ipv4_address = each.value.ip
  ipv4_gateway = var.net_work_gateway_address
  vm_tags      = ["terraform", "ubuntu", "k8s"]

}



# 自动生成 ansible 清单文件
resource "local_file" "tf_ansible_inventory_file" {
  content = <<-EOF
[k8s]
%{for vm in var.servers~}
${vm.name}   ansible_host=${split("/", vm.ip)[0]}
%{endfor~}

EOF

  filename        = "${path.module}/../../ansible/inventory.ini"
  file_permission = "0644"
}

resource "local_file" "ssh_config" {
  content = <<-EOF
%{for vm in var.servers~}
Host ${vm.name}
    HostName    ${split("/", vm.ip)[0]}
    IdentityFile ${var.ssh_local_private_key_path}
    PreferredAuthentications publickey
    User root
    Port 22

%{endfor~}
EOF

  filename        = "${path.module}/../../keys/ssh/config.conf"
  file_permission = "0644"
}

output "vm_details" {
  description = "虚拟机详细信息"
  value = {
    for key, vm in module.vm_k8s_nodes : key => {
      name  = vm.vm_name
      vm_id = vm.vm_id
      node  = vm.target_node
      ip    = vm.vm_ipv4_address
    }
  }
}


# # debug out
# resource "local_file" "debug_file_out" {
#   content = <<-EOF
# [test]
# 192.168.1.15

# [k8s]
# %{for vm in var.servers~}
# ${vm.name}   ansible_host=${split("/", vm.ip)[0]}
# %{endfor~}

# EOF

#   filename        = "${path.module}/../../debug.log"
#   file_permission = "0644"
# }
