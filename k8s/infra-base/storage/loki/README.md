
```sh
# 先放置s3的key
kubectl apply -f k8s/infra-base/storage/loki/secret-crypto.yaml

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm search repo grafana

helm show values grafana/loki --version 7.0.0 > default-values.yaml

# --dry-run
helm upgrade --install loki grafana/loki \
  --namespace monitoring \
  --values values.yaml \
  --version 7.0.0

kubectl get pods -n monitoring -l app.kubernetes.io/name=loki

```

```sh
helm pull grafana/loki --version 7.0.0 --untar

helm uninstall loki -n monitoring
```

http://loki-gateway.monitoring.svc.cluster.local/

`X-Scope-OrgId`


```sh
# 测试写入
curl -H "Content-Type: application/json" -XPOST -s "http://127.0.0.1:3100/loki/api/v1/push"  \
--data-raw "{\"streams\": [{\"stream\": {\"job\": \"test\"}, \"values\": [[\"$(date +%s)000000000\", \"fizzbuzz\"]]}]}" \
-H X-Scope-OrgId:foo
```
