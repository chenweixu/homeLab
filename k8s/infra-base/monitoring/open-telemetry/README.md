
```sh
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts

helm repo update

helm search repo open-telemetry

helm show values open-telemetry/opentelemetry-operator \
    --version 0.110.0 > opentelemetry-operator-0.110.0-values.yaml

helm upgrade --install opentelemetry-operator \
    open-telemetry/opentelemetry-operator -n monitoring \
    -f values.yaml

helm uninstall opentelemetry-operator -n monitoring

```
