
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.100.0"
    }
  }
}


# 创建模板 VM
resource "proxmox_virtual_environment_vm" "ubuntu-2404-v1" {
    name = "template-ubuntu-2404-v1"
    node_name = "pve"
    vm_id     = 9000

    bios                                 = "ovmf"
    acpi                                 = true
    boot_order                           = ["scsi0",]
    delete_unreferenced_disks_on_destroy = true
    description                          = null
    keyboard_layout                      = "en-us"
    kvm_arguments                        = null
    machine                              = "q35"
    migrate                              = false

    network_device {
        bridge = "vmbr0"
        model  = "virtio"
    }

    on_boot                              = false
    pool_id                              = null
    protection                           = false
    purge_on_destroy                     = true
    reboot                               = false
    reboot_after_update                  = true
    scsi_hardware                        = "virtio-scsi-single"
    started                              = false
    stop_on_destroy                      = false
    tablet_device                        = true
    tags                                 = []
    template                             = true
    timeout_clone                        = 1800
    timeout_create                       = 1800
    timeout_migrate                      = 1800
    timeout_reboot                       = 1800
    timeout_shutdown_vm                  = 1800
    timeout_start_vm                     = 1800
    timeout_stop_vm                      = 300

    agent {
        enabled = true
        timeout = "15m"
        trim    = false
        type    = "virtio"
    }

    cpu {
        affinity     = null
        architecture = null
        cores        = 2
        flags        = []
        hotplugged   = 0
        limit        = 0
        numa         = false
        sockets      = 1
        type         = "host"
    }

    disk {
        aio               = "io_uring"
        backup            = true
        cache             = "none"
        datastore_id      = "local-lvm"
        discard           = "ignore"
        file_format       = "raw"
        file_id           = null
        import_from       = null
        interface         = "scsi0"
        iothread          = true
        path_in_datastore = "base-9000-disk-0"
        replicate         = true
        serial            = null
        size              = 3
        ssd               = false
    }

    efi_disk {
        datastore_id      = "local-lvm"
        file_format       = "raw"
        pre_enrolled_keys = true
        type              = "2m"
    }

    initialization {
        datastore_id         = "local-lvm"
        file_format          = null
        interface            = "ide2"
        meta_data_file_id    = null
        network_data_file_id = null
        type                 = null
        user_data_file_id    = null
        vendor_data_file_id  = null
    }

    memory {
        dedicated      = 1024
        floating       = 0
        hugepages      = null
        keep_hugepages = false
        shared         = 0
    }

    operating_system {
        type = "l26" # Linux 2.6+ Kernel
    }

    serial_device {
        device = "socket"
    }

    vga {
        clipboard = null
        memory    = 16
        type      = "serial0"
    }

}
