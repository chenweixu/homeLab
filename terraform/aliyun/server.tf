
resource "alicloud_instance" "web1" {
  auto_release_time                   = null
  availability_zone                   = var.general_instance_zone
  credit_specification                = null
  dedicated_host_id                   = null
  deletion_protection                 = false
  deployment_set_id                   = null
  description                         = null
  enable_jumbo_frame                  = false
  hpc_cluster_id                      = null
  http_endpoint                       = null
  http_tokens                         = null
  image_id                            = "aliyun_3_x64_20G_alibase_20230727.vhd"
  instance_charge_type                = "PrePaid"
  instance_type                       = "ecs.e-c1m1.large"
  internet_charge_type                = "PayByBandwidth"
  internet_max_bandwidth_out          = 3
  key_name                            = null
  maintenance_action                  = "AutoRecover"
  maintenance_notify                  = false
  network_interface_traffic_mode      = "Standard"
  period_unit                         = "Month"
  private_pool_options_id             = null
  private_pool_options_match_criteria = "None"
  queue_pair_number                   = 0
  renewal_status                      = "Normal"
  resource_group_id                   = null
  role_name                           = null
  security_groups = [
    alicloud_security_group.group1.id,
  ]
  spot_duration                       = 0
  spot_price_limit                    = 0
  spot_strategy                       = "NoSpot"
  stopped_mode                        = "Not-applicable"
  system_disk_auto_snapshot_policy_id = null
  system_disk_category                = "cloud_essd_entry"
  system_disk_description             = null
  system_disk_encrypted               = false
  system_disk_kms_key_id              = null
  system_disk_name                    = null
  system_disk_performance_level       = null
  system_disk_provisioned_iops        = 0
  system_disk_size                    = 40
  system_disk_storage_cluster_id      = null
  tags                                = {}
  user_data                           = null
  volume_tags                         = {}
  vpc_id                              = alicloud_vpc.vpc1.id
  vswitch_id                          = alicloud_vswitch.sw-core.id


  cpu_options {
    core_count       = 1
    threads_per_core = 2
    topology_type    = null
  }

  image_options {
    login_as_non_root = false
  }

  timeouts {}
}
