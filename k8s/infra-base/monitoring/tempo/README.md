
```sh
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update grafana
helm search repo grafana

helm show values grafana/tempo --version 1.24.4 > dafult-values.yaml

helm upgrade --install tempo grafana/tempo --version 1.24.4 -n monitoring \
    -f values.yaml --dry-run

helm uninstall tempo

```


docker.io/grafana/tempo:2.9.0
harbor.chenwx.top/docker.io/grafana/tempo:2.9.0
