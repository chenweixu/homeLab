output "template_id" {
  value = proxmox_virtual_environment_vm.this.id
}

output "template_name" {
  value = proxmox_virtual_environment_vm.this.name
}

output "template_node" {
  value = proxmox_virtual_environment_vm.this.node_name
}

output "template_snippet" {
  value = proxmox_virtual_environment_file.cloud_config.id
}
