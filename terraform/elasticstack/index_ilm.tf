
resource "elasticstack_elasticsearch_index_lifecycle" "my_ilm" {
  name = "my_ilm_policy"

  # Hot 阶段: 索引创建后立即生效, 配置 Rollover 条件
  hot {
    min_age = "0ms"
    set_priority {
      priority = 100 # hot 阶段优先级高
    }
    rollover {
      max_age  = "1d"   # 索引创建满 1 天触发滚动
      max_size = "50gb" # 主分片达到 50GB 触发滚动
    }
    readonly {}
  }

  # # Warm 阶段: 索引变为只读, 可配置 forcemerge 和分片收缩
  warm {
    min_age = "7d"
    set_priority {
      priority = 10
    }
    readonly {
      enabled = true # 设为只读
    }
    forcemerge {
      max_num_segments = 1 # 合并为 1 个段, 优化查询
    }
    allocate {
      exclude = jsonencode({
        box_type = "hot"
      })
      number_of_replicas    = 1 # 指定副本数
      total_shards_per_node = 200
    }
  }

  # Cold 阶段(可选): 数据移至冷节点存储
  cold {
    min_age = "30d"
    allocate {
      number_of_replicas = 0 # 冷数据副本数可减少
    }
  }

  delete {
    min_age = "60d"
    delete {
      delete_searchable_snapshot = true
    }
  }
}
