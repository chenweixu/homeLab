

## 安装 --dry-run
```sh

# 提前准备镜像
# ghcr.io/grafana/grafana-operator:v5.23.0
# harbor.chenwx.top/ghcr.io/grafana/grafana-operator:v5.23.0

helm upgrade -i grafana-operator oci://ghcr.io/grafana/helm-charts/grafana-operator --version 5.23.0 -n monitoring -f values.yaml
```
