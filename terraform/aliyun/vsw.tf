
resource "alicloud_vswitch" "sw-core" {
  cidr_block           = "172.17.0.0/20"
  description          = "System created default virtual switch."
  enable_ipv6          = null
  ipv6_cidr_block_mask = 255
  is_default           = null
  tags                 = {}
  vpc_id               = alicloud_vpc.vpc1.id
  vswitch_name         = "sw-core"
  zone_id              = var.general_instance_zone
  timeouts {
    create = null
    delete = null
    update = null
  }
}

resource "alicloud_vswitch" "ack" {
  cidr_block           = "172.17.16.0/20"
  description          = null
  enable_ipv6          = null
  ipv6_cidr_block_mask = null
  is_default           = null
  tags                 = {}
  vpc_id               = alicloud_vpc.vpc1.id
  vswitch_name         = "sw-ack"
  zone_id              = var.general_instance_zone
}


output "vswitch_id_core" {
  description = "core交换机的ID"
  value       = alicloud_vswitch.sw-core.id
}


output "vswitch_id_ack" {
  description = "core交换机的ID"
  value       = alicloud_vswitch.ack.id
}
