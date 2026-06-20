
Kite

一个新的面板, 看起来比较现代化和个性化

```
https://github.com/zxh326/kite

https://kite.zzde.me/
https://kite.zzde.me/zh/config/chart-values.html
https://kite.zzde.me/zh/guide/installation.html
```

## docker run
```sh
docker run --rm -p 8080:8080 \
    -v ~/.kube/config:/home/nonroot/.kube/config \
    ghcr.io/zxh326/kite:latest
```


helm install
```sh
helm repo add kite https://kite-org.github.io/kite/
helm repo update
helm search repo kite
helm show values kite/kite --version 0.12.3 > default-values.yaml
defaults.yaml

helm template kite kite/kite --namespace cwx \
    -f values.yaml --dry-run

helm upgrade --install kite kite/kite --namespace cwx -f values.yaml

```
