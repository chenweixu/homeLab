

## 安装 --dry-run
```sh

# 提前准备镜像
# ghcr.io/grafana/grafana-operator:v5.23.0
# harbor.chenwx.top/ghcr.io/grafana/grafana-operator:v5.23.0

helm upgrade -i grafana-operator \
    oci://ghcr.io/grafana/helm-charts/grafana-operator \
    --version 5.23.0 -n monitoring -f values.yaml
```


## git sync

1. 创建 grafana service account, 并获取 token
2. 准备 repository.yaml 文件填充 git 仓库的 token, 需要有写的权限
3. 配置 gcx


repository.yaml
```yaml
secure:
  token: { create: "---替换为实际的token------" }
```

### gcx

~/.config/gcx/config.yaml
```yaml
contexts:
  default: {}
  local:
    grafana:
      server: https://grafana.chenwx.top
      token: glsa_xxxxxxx
      auth-method: token
      org-id: 1
current-context: local
```

cmd
```sh
source <(gcx completion bash)

# 上传仓库配置
gcx resources push -p ./repository.yaml

# 查看数据源, 获取的 uid
gcx datasources list

# 更新 git_sync 下的yaml文件中的数据源名称或者id

```
