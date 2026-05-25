
https://helm.cilium.io/
https://github.com/cilium/cilium/releases/tag/v1.17.6
https://github.com/cilium/cilium/tree/v1.17.6/install/kubernetes/cilium

https://github.com/cilium/cilium-cli/releases/download/v0.16.22/cilium-linux-amd64.tar.gz


不用再区分 install 和 upgrade
```sh
kubectl apply -k k8s/infra-base/network/cilium

```


```sh
# 添加源
helm repo add cilium https://helm.cilium.io

helm repo update cilium

helm search repo cilium

helm pull cilium/cilium
tar xvf cilium-*.tgz

hashSeed=$(head -c12 /dev/urandom | base64 -w0)

# 安装预览
helm template cilium ./cilium  -f values-home.yaml --namespace kube-system --dry-run

# 安装
helm install cilium ./cilium  -f values-home.yaml --namespace kube-system

# 更新
helm upgrade cilium ./cilium  -f values-home.yaml --namespace kube-system

# 卸载
helm uninstall cilium -n kube-system

```

hubble-ui
```sh
# 转发UI
kubectl port-forward --address 0.0.0.0 \
    --namespace kube-system svc/hubble-ui 3080:80

# http://192.168.5.5:3080
```

ippools
```sh
kubectl get ippools
kubectl describe ippools/pool-30

# 查看ip分配情况
kubectl get ippools -o jsonpath='{.items[*].status.conditions[?(@.type!="cilium.io/PoolConflict")]}' | jq

```

l2announcement
```sh

# 查看状态
kubectl describe l2announcement

# 检查租赁
kubectl -n kube-system get lease
kubectl -n kube-system get lease/cilium-l2announce-traefik-traefik -o yaml

# 查看服务分配的ip地址
kubectl get svc --all-namespaces -o wide | grep LoadBalancer


```

debug

```sh
kubectl -n kube-system exec -it daemonset/cilium -- bash

cilium service list

cilium service list | grep LoadBalancer

```

## update

1.17.6 --> 1.19.2

备份
```sh
# 获取当前 Helm values
helm get values cilium -n kube-system -o yaml > cilium-values-backup.yaml

# 备份重要 CRD(可选)
kubectl get crd -o yaml | grep -E "cilium|gateway" > crd-backup.yaml

# 准备镜像

skopeo copy --override-arch amd64 --override-os linux \
    docker://quay.io/cilium/cilium:v1.19.1 \
    docker://harbor.chenwx.top/quay.io/cilium/cilium:v1.19.1

skopeo copy --override-arch amd64 --override-os linux \
    docker://quay.io/cilium/operator-generic:v1.19.2 \
    docker://harbor.chenwx.top/quay.io/cilium/operator-generic:v1.19.2

```

升级
```sh
helm repo update
helm search repo cilium

# 查看 Cilium 1.19.2 版本的完整默认 values
helm show values cilium/cilium --version 1.19.2 > cilium-1.19.2-default-values.yaml

# 升级预览
helm upgrade cilium cilium/cilium \
  --namespace kube-system \
  --version 1.19.2 \
  -f values-home-1.19.2.yaml \
  --dry-run --debug > cilium-upgrade-dryrun.yaml

# 升级
helm upgrade cilium cilium/cilium \
  --namespace kube-system \
  --version 1.19.2 \
  -f values.yaml

```




验证升级结果
```sh

# 检查 Cilium Agent 版本
kubectl -n kube-system get pods -l k8s-app=cilium -o yaml | grep "image:.*cilium:"

kubectl -n kube-system get pods -l k8s-app=cilium

# 检查 Cilium 状态
cilium status

# 检查 Envoy DaemonSet 是否正常
kubectl -n kube-system get daemonset cilium-envoy

# 验证 Gateway API 是否启用
kubectl get gatewayclasses
cilium    io.cilium/gateway-controller    True       19m
```
