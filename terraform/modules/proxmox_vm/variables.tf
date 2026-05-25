variable "vm_name" {
  description = "虚拟机名称"
  type        = string
}

# variable "vm_id" {
#   description = "虚拟机 ID"
#   type        = number
# }

variable "target_node" {
  description = "目标 PVE 节点"
  type        = string
}

variable "template_name" {
  description = "模板名字"
  type        = string
}

# variable "iso_datastore_id" {
#     description = "存放 cloud-init 文件的存储设备"
#     default = "local"
# }


# variable "template_id" {
#   description = "源模板的 ID"
#   type        = string
# }

variable "ipv4_address" {
  description = "IPv4 地址 (CIDR 格式)"
  type        = string
}

variable "ipv4_gateway" {
  description = "网关地址"
  type        = string
}

variable "cpu_core" {
  description = "cpu核心"
  type        = number
  default     = 2
}

variable "memory_size" {
  description = "内存大小"
  type        = number
  default     = 1024
}


variable "system_disk_size" {
    type        = number
  default = 30
}

variable "data_disk_size" {
    type        = number
  default = 20
}

variable "datastore_id" {
  default = "local-lvm"
}

variable "vm_tags" {
  type        = list(string)
  description = "虚拟机标签列表"
  default     = ["terraform", "ubuntu"]
}


variable "additional_disks" {
  description = "额外的磁盘列表配置"
  type = list(object({
    interface    = string
    size         = number
    datastore_id = optional(string)     # 设为可选，默认可继承全局配置
    iothread     = optional(bool, true)
  }))
  default = [] # 默认为空列表，即不增加数据盘
}

variable "ssh_public_key_ubuntu" {
  description = "Ubuntu 用户 SSH 公钥内容"
  type        = string
}
