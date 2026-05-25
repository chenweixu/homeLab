# 显式指定 disable_mlock, 因为没有 swap
disable_mlock = true

# config.hcl 内容
storage "raft" {
  path    = "/vault/data"
  node_id = "node1"
}


listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

ui = true
api_addr = "https://vault.chenwx.top"

cluster_addr = "http://vault:8201"
