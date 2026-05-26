
```sh
helm repo add authelia https://charts.authelia.com
helm repo update
helm search repo authelia

helm install authelia authelia/authelia --version 0.11.5

helm show values authelia/authelia --version 0.11.5 > default-values.yaml
```

```sql
CREATE USER authelia WITH PASSWORD '-----------';
CREATE DATABASE authelia OWNER authelia;
GRANT ALL PRIVILEGES ON DATABASE authelia TO authelia;

DROP DATABASE authelia;

```

```sh
# install
kustomize build --enable-helm ./ | kubectl apply -f -
kustomize build --enable-helm k8s/infra/authelia | kubectl apply -f -

# install2
helm upgrade --install authelia authelia/authelia \
    --version 0.11.5 \
    -n authelia \
    -f k8s/infra/authelia/values.yaml
```
