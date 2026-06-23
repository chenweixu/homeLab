vault_address        = "https://vault.chenwx.top"
proxmox_cluster_name = "homeLab"

default_proxmox_node = "pve"
image_url            = "http://files.services.wait/soft/noble-server-cloudimg-amd64.img"

net_work_gateway_address = "192.168.5.254"

ssh_local_private_key_path = "/home/wait/git/env/keys/cwx/cwx_id_ed25519"

servers = {
  node1 = {
    name        = "node-70",
    ip          = "192.168.5.70/24",
    cpu         = 4,
    ram         = 8192,
    disk        = 40,
    target_node = "pve"
  }
  node2 = {
    name        = "node-71",
    ip          = "192.168.5.71/24",
    cpu         = 4,
    ram         = 8192,
    disk        = 40,
    target_node = "pve"
  }
  node3 = {
    name        = "node-72",
    ip          = "192.168.5.72/24",
    cpu         = 4,
    ram         = 8192,
    disk        = 40,
    target_node = "pve"
  }
  node4 = {
    name        = "node-73",
    ip          = "192.168.5.73/24",
    cpu         = 4,
    ram         = 8192,
    disk        = 40,
    target_node = "pve"
  }
}
