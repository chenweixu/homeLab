

# 阿里云 webhook
Cert-Manager 本身不支持阿里云 DNS, 所以需部署第三方 Webhook 插件
实现与阿里云 DNS API 的对接


关于 groupName, 如果集群里只有一个域名需要获取证书, 或者多个域名都是同一个阿里云账号下的, 这个 groupName 叫什么都无所谓; 如果有多个域名并且属于不同阿里云账号, 甚至其它域名供应商的, 则需要每个域名供应商的账号都采用唯一的命名

## 问题1
cert-manager-alidns-webhook 这个包没有正确渲染 namespace,
如果不采用 helm 指定ns 安装, 则会因为没有 namespace 导致安装到 default ns 去;
而使用 Kustomization 暂时解决不了这个问题, 或者通过 path or replacements 等比较繁琐的方式;

所以这里还是通过 helm 安装;
argocd 需要通过单独的 application.yml helm 模式进行安装;


---

to 本地 oci repo
```sh
helm pull cert-manager-alidns-webhook/alidns-webhook --version 0.8.3
helm push alidns-webhook-0.8.3.tgz oci://harbor.chenwx.top/public

helm pull oci://harbor.chenwx.top/public/alidns-webhook --version 39.0.7
```


```sh
skopeo copy --override-arch amd64 --override-os linux \
    docker://ghcr.io/devmachine-fr/cert-manager-alidns-webhook/cert-manager-alidns-webhook:0.3.1 \
    docker://harbor.chenwx.top/ghcr.io/devmachine-fr/cert-manager-alidns-webhook/cert-manager-alidns-webhook:0.3.1
```


```sh
helm repo add cert-manager-alidns-webhook https://devmachine-fr.github.io/cert-manager-alidns-webhook

helm repo update cert-manager-alidns-webhook
helm search repo cert-manager-alidns-webhook


helm show values cert-manager-alidns-webhook/alidns-webhook --version 0.8.3 > default-values.yaml

helm install alidns-webhook cert-manager-alidns-webhook/alidns-webhook --version 0.8.3


helm upgrade --install alidns-webhook cert-manager-alidns-webhook/alidns-webhook \
    --version 0.8.3 --namespace cert-manager -f values.yaml


kubectl apply -f secret-crypto.yaml

```

---

# 验证 Issuer 状态(Ready 为 True 表示正常)
```
kubectl get clusterissuer alidns-letsencrypt-staging-clusterissuer


kubectl apply -f wildcard-certificate-staging.yaml
kubectl get certificates -n cert-manager
kubectl get secrets -n cert-manager | grep myk8s-online

```

后续 Ingress 使用的证书名字
secretName: myk8s-online-tls-staging


```
# helmCharts:
#   - name: cert-manager-alidns-webhook
#     repo: https://devmachine-fr.github.io
#     releaseName: alidns-webhook
#     namespace: cert-manager
#     version: 0.8.3
#     valuesFile: values.yaml

```
