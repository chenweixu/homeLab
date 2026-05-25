

## install gateway crd
```sh
# Install Traefik RBACs.
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.6/docs/content/reference/dynamic-configuration/kubernetes-gateway-rbac.yml
```


## 安装-升级
```sh
# kubectl kustomize --enable-helm k8s/services_admin/traefix | kubectl apply -f -

```


## helm 手动安装

```sh
helm repo add traefik https://traefik.github.io/charts
helm repo update
helm search repo traefik

helm show values traefik/traefik --version 39.0.7 > traefik-defaults.yaml


# 预览
helm template traefik traefik/traefik --namespace cwx \
    -f k8s/services_admin/traefix/values.yaml --dry-run


helm install traefik traefik/traefik --version 39.0.7 --namespace cwx \
    -f k8s/services_admin/traefix/values.yaml

helm upgrade traefik traefik/traefik --version 39.0.7 --namespace cwx \
    -f k8s/services_admin/traefix/values.yaml

# 从本地 oci 仓库更新
helm upgrade --install traefik oci://harbor.chenwx.top/public/traefik \
    --version 39.0.7 -n cwx \
    -f k8s/infra/gateway/traefix/values.yaml

# 卸载
helm uninstall traefik -n cwx
```


## 转储 charts 包到本地 oci
```sh
helm pull traefik/traefik --version 39.0.7
helm push traefik-39.0.7.tgz oci://harbor.chenwx.top/public
helm pull oci://harbor.chenwx.top/public/traefik --version 39.0.7

```


## 其它
```sh
# 查看服务状态注解
wait@ub05:~$ kubectl -n cwx get svc/traefik -o jsonpath='{.status.conditions}' | jq
[
  {
    "lastTransitionTime": "2025-08-04T17:36:36Z",
    "message": "",
    "reason": "satisfied",
    "status": "True",
    "type": "cilium.io/IPAMRequestSatisfied"
  }
]

```
