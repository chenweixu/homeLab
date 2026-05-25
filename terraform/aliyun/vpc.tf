resource "alicloud_vpc" "vpc1" {
  cidr_block                                  = "172.17.0.0/16"
  classic_link_enabled                        = false
  description                                 = "System created default VPC."
  dns_hostname_status                         = "DISABLED"
  dry_run                                     = null
  enable_ipv6                                 = true
  force_delete                                = null
  ipv4_cidr_mask                              = null
  ipv4_ipam_pool_id                           = null
  ipv6_isp                                    = null
  is_default                                  = null
  resource_group_id                           = alicloud_resource_manager_resource_group.default.id
  system_route_table_description              = null
  system_route_table_name                     = null
  system_route_table_route_propagation_enable = true
  tags                                        = {}
  user_cidrs                                  = []
  vpc_name                                    = null
  timeouts {
    create = null
    delete = null
    update = null
  }
}

output "vpc_id" {
  description = "主 VPC ID"
  value       = alicloud_vpc.vpc1.id
}

output "vpc_cidr_block_v4" {
  description = "主 VPC ID"
  value       = alicloud_vpc.vpc1.cidr_block
}
