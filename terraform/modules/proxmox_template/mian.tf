
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.100.0"
    }
  }
}

# 下载 Cloud 镜像
resource "proxmox_download_file" "cloud_image" {
  content_type = "import"               # 对应 qm importdisk
  datastore_id = var.iso_datastore_id   # 下载存放的存储
  node_name    = var.target_node
  url          = var.image_url
  file_name    = "${var.template_name}.qcow2"
}

# 生成 Cloud-Config Snippet
resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = var.iso_datastore_id
  node_name    = var.target_node

  source_raw {
    # 动态渲染 Cloud-init, 注入公钥
    data = templatefile("${path.module}/files/cloud-init.yaml", {
        ssh_public_key_admin  = trimspace(var.ssh_public_key_admin)
        ssh_public_key_ubuntu = trimspace(var.ssh_public_key_ubuntu)
    })
    file_name = "${var.template_name}-config.yaml"
  }
}

# 创建模板 VM
resource "proxmox_virtual_environment_vm" "this" {
  name      = var.template_name
  node_name = var.target_node
  tags      = ["terraform", "template", var.os_family]

    # 硬件架构配置 (对应 q35 和 ovmf)
  machine    = "q35"
  bios       = "ovmf"
  template   = true             # 开启此项, 将其标记为模板
  started    = false            # 完成后不开机, 默认就是 false, 但模板还是增加标注
  boot_order = ["scsi0"]        # 引导顺序
  keyboard_layout = "en-us"

  # 并发性(多个磁盘能否并行)
  scsi_hardware = "virtio-scsi-single"

  cpu {
    cores = var.cpu_cores
    type  = "host"
  }

  memory {
    dedicated = var.memory_size
  }

  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }


  operating_system {
    type = "l26" # Linux 2.6+ Kernel
  }

  # 串口设备
  serial_device {
    device = "socket"
  }

    # 对应 qm set --efidisk0
  efi_disk {
    datastore_id = var.vm_datastore_id
    file_format  = "raw"
    type         = "4m"
  }

  # 对应 qm importdisk + resize 逻辑
  disk {
    datastore_id = var.vm_datastore_id
    interface    = "scsi0"
    iothread     = true
    size         = var.disk_size        # 初始为 3G

    # 单次 IO 请求的异步支持, 需要较新的内核 5.10+
    aio          = "io_uring"
    file_id      = proxmox_download_file.cloud_image.id
  }

  initialization {
    datastore_id = var.vm_datastore_id
    interface    = "ide2"           # Cloud-init 驱动器


    # user_data_file_id = proxmox_virtual_environment_file.cloud_config.id

    ip_config {
      ipv4 {
        # 如果变量为空字符串, 则设为 dhcp; 否则设为用户输入的 IP
        address = var.ipv4_address == "" ? "dhcp" : var.ipv4_address

        gateway = var.ipv4_address == "" ? null : var.ipv4_gateway_ip
      }
    }

    dns {
      servers = var.dns_address
    }

  }

  vga {
    memory = 16
    type   = "serial0"
  }

# 必须开启, 配合 Cloud-init 安装的 agent
  agent { enabled = true }
}
