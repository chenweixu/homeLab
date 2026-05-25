output "vm_id" {
  description = "创建的虚拟机 ID"
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "vm_name" {
  value = proxmox_virtual_environment_vm.this.name
}

output "vm_ipv4_address" {
  description = "虚拟机的 IPv4 地址"
  # 注意: 这里取决于 Provider 返回值, 通常从 initialization 或 network_interface 获取
  value = proxmox_virtual_environment_vm.this.initialization[0].ip_config[0].ipv4[0].address
}

output "target_node" {
  value = var.target_node
}
