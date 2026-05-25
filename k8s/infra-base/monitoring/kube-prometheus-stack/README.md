
## helm 管理
```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm search repo prometheus-community

## to 本地 oci 仓库
helm pull prometheus-community/kube-prometheus-stack --version 84.1.0
helm push kube-prometheus-stack-84.1.0.tgz oci://harbor.chenwx.top/public

rm kube-prometheus-stack-84.1.0.tgz
helm pull oci://harbor.chenwx.top/public/kube-prometheus-stack --version 84.1.0

helm show values prometheus-community/kube-prometheus-stack  --version 84.1.0 > values.yaml

```

## 部署
```sh
# 创建 ns 和基础配置
kubectl apply -k k8s/infra-base/kube-prometheus-stack

# 部署 可选 --dry-run
helm upgrade --install prometheus-stack oci://harbor.chenwx.top/public/kube-prometheus-stack \
    --version 84.1.0 \
    -n monitoring \
    -f value.yaml


# 卸载
helm -n monitoring uninstall prometheus-stack

```

## 事件
controller scheduler 默认只监听 127.0.0.1 所以需要修改监听地址;
静态pod, 修改文件后自动重启生效
```sh
sed -i '/127.0.0.1/s/127.0.0.1/0.0.0.0/' kube-controller-manager.yaml
sed -i '/127.0.0.1/s/127.0.0.1/0.0.0.0/' kube-scheduler.yaml
```


## 镜像准备
```sh
# 定义镜像列表
images=(
  "registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.18.0"
  "ghcr.io/jkroepke/kube-webhook-certgen:1.8.2"
  "docker.io/grafana/grafana:13.0.1"
  "quay.io/prometheus-operator/prometheus-config-reloader:v0.90.1"
  "quay.io/prometheus-operator/prometheus-operator:v0.90.1"
  "quay.io/prometheus/prometheus:v3.11.2"
  "quay.io/prometheus/alertmanager:v0.32.0"
)

# 循环同步
for image in "${images[@]}"; do
  echo "正在同步: $image"
  skopeo copy --override-arch amd64 --override-os linux \
    "docker://$image" \
    "docker://harbor.chenwx.top/public/${image#*/}"
done
```



## 服务发现示例

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: app-monitor
  namespace: production
  labels:
    release: monitoring         # 这个是安装 kube-prometheus-stack 时的 release 名称
spec:
  selector:
    matchLabels:
      app: my-service
  endpoints:
    - port: http
      interval: 30s
      path: /metrics
```


## 告警测试
```sh
curl -X POST http://prometheus-stack-kube-prom-alertmanager.monitoring:9093/api/v2/alerts \
  -H "Content-Type: application/json" \
  -d '[{
    "labels": {
      "alertname": "test",
      "severity": "warning"
    },
    "annotations": {
      "summary": "测试告警"
    }
  }]'

```


# 调用管理 API重新加载配置
```sh
curl -X POST https://prometheus.chenwx.top/-/reload
```
