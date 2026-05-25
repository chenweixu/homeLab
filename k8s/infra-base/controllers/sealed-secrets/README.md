
使用示例
```sh
kubectl create secret generic my-secret \
  --from-literal=username=admin \
  --from-literal=password=123456 \
  --dry-run=client -o yaml | \
  kubeseal --cert keys/sealed-secrets/certificate/sealed-secrets.crt --scope namespace-wide --format yaml > sealed-secret.yaml

```
