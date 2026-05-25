terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.100.0"
    }
  }
}

# 通过模板名字查询模板ID
data "proxmox_virtual_environment_vms" "template" {
  node_name = var.target_node

  # 9000 模板名字过滤
  filter {
    name   = "name"
    values = [var.template_name]
  }
}

# resource "proxmox_virtual_environment_file" "cloud_init_config" {
#   content_type = "snippets"
#   datastore_id = var.iso_datastore_id
#   node_name    = var.target_node
#   source_raw {
#     data = file("${path.module}/files/cloud-init.yaml")
#     file_name = "cloud-init-config-ub24.yaml"
#   }
# }


# 子模块内的资源名称通常统一命名为 this
# 因为它是唯一的局部实例，父模块通过 module.xxx 来区分
resource "proxmox_virtual_environment_vm" "this" {
  name      = var.vm_name
  node_name = var.target_node
#   vm_id     = var.vm_id

  bios    = "ovmf"
  machine = "q35"
  tags    = var.vm_tags

  clone {
    vm_id = data.proxmox_virtual_environment_vms.template.vms[0].vm_id
    # full = true # 正式环境建议开启
  }

  started = true

  cpu {
    cores        = var.cpu_core
    type         = "host"
    sockets      = 1
  }

  memory {
    dedicated = var.memory_size
  }

  # 系统盘
  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"
    size         = var.system_disk_size
  }

  # 数据盘
#   disk {
#     datastore_id = var.datastore_id
#     interface    = "scsi1"
#     size         = var.data_disk_size
#     file_format  = "raw"
#     iothread     = true
#   }

# 2. 动态数据盘 (按需生成)
  dynamic "disk" {
    for_each = var.additional_disks
    content {
      # disk.value 指向当前循环的对象
      datastore_id = disk.value.datastore_id != null ? disk.value.datastore_id : var.datastore_id
      interface    = disk.value.interface
      size         = disk.value.size
      file_format  = "raw"
      iothread     = disk.value.iothread
    }
  }

  initialization {
    datastore_id = var.datastore_id
    interface    = "ide2"

    # vendor_data_file_id = proxmox_virtual_environment_file.cloud_init_config.id

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
      }
    }

    dns {
      servers = ["192.168.5.9", "8.8.8.8"]
    }

    user_account {
      username = "ubuntu"
    #   password = "password"
      keys     = [
        var.ssh_public_key_ubuntu
      ]
    }

  }

  lifecycle {
    ignore_changes = [
      network_device[0].mac_address,
      initialization[0].user_account[0].keys,
    ]
  }
}
