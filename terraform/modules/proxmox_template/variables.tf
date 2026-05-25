
variable "target_node" { type = string }
variable "template_name" { type = string }

variable "ssh_public_key_admin" {
  description = "管理员 SSH 公钥内容"
  type        = string
}

variable "ssh_public_key_ubuntu" {
  description = "Ubuntu 用户 SSH 公钥内容"
  type        = string
}


variable "image_url" { type = string }

variable "iso_datastore_id" { default = "local" }
variable "vm_datastore_id" { default = "local-lvm" }

variable "cpu_cores" { default = 2 }
variable "memory_size" { default = 1024 }
variable "disk_size" { default = 15 }


variable "network_bridge" { default = "vmbr0" }
variable "os_family" { default = "ubuntu" }

variable "dns_address" {
  type        = list(string)
  description = "dns addr list"
  default     = []
}

variable "ipv4_address" {
    type            = string
    default = ""
    description = "VM 的静态 IP 地址, 格式为 192.168.1.10/24; 留空则使用 DHCP; "

    validation {
        condition     = var.ipv4_address == "" || can(cidrhost(var.ipv4_address, 0))
        error_message = "输入的 IP 地址格式不正确, 必须是有效的 CIDR 格式(如 192.168.1.10/24); "
    }
}

# 网关校验, 必须在 ip_address 所在的网段内
variable "ipv4_gateway_ip" {
  type        = string
  default     = ""
  description = "IP gateway address (eg. 10.10.10.1)"
  validation {
    condition     = var.ipv4_gateway_ip == "" || can(cidrhost("${var.ipv4_gateway_ip}/32", 0))
    error_message = "输入的必须是合法的 IPv4 地址(例如 10.10.10.1); "
  }
}
