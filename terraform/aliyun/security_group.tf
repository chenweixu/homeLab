
resource "alicloud_security_group" "group1" {
  description         = "System created security group."
  inner_access_policy = "Accept"
  resource_group_id   = null
  security_group_type = "normal"
  tags                = {}
  vpc_id              = alicloud_vpc.vpc1.id
  timeouts {
    create = null
    delete = null
    update = null
  }
}
