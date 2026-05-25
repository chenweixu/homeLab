
## doc
https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/data_source


# load dashboard
terraform import grafana_dashboard.cwx-test 82e8a46a-1e5a-4a85-ac33-1c274b21e675


ui 导出json

清理内容
- 移除 id 字段
- 移除 version 字段
- 删除 metadata 的 name 字段
