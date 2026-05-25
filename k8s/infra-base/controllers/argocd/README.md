部署
```sh
kubectl create namespace argocd

https://argoproj.github.io/argo-helm/

helm repo add argo https://argoproj.github.io/argo-helm

helm repo update argo
helm search repo argo
helm show values argo/argo-cd --version 9.5.14 > default-values.yaml


helm upgrade --install argocd argo/argo-cd \
    --version 9.5.14 --namespace argocd -f values.yaml  --dry-run

helm upgrade --install argocd argo/argo-cd \
    --version 9.5.14 --namespace argocd -f values.yaml  --dry-run | grep 'image: '

helm upgrade --install argocd argo/argo-cd \
    --version 9.5.14 --namespace argocd -f values.yaml


kubectl apply -f traefik-IngressRoute.yml
```

```sh

# 获取 admin 密码
kubectl -n argocd get secret argocd-initial-admin-secret \
    -o jsonpath="{.data.password}" | base64 -d


# login
argocd login argocd.chenwx.top --username admin --password xxxxxxx --grpc-web

argocd app list

```

```sh
# 添加仓库私钥
argocd repo add ssh://git@git.chenwx.top:10022/chenwx/homeLab.git \
  --ssh-private-key-path keys/cwx/cwx_id_ed25519 \
  --insecure-skip-server-verification
```
