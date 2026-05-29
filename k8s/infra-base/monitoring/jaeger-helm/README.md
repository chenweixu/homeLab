

```sh
helm repo add jaegertracing https://jaegertracing.github.io/helm-charts
helm repo update jaegertracing
helm search repo jaegertracing

helm show values jaegertracing/jaeger --version 4.8.0 > dafult-values.yaml

helm upgrade --install jaeger jaegertracing/jaeger \
    --version 4.8.0 \
    -n monitoring \
    -f value.yaml

helm uninstall -n monitoring jaeger
```
