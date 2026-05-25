
## 版本支持列表
https://cert-manager.io/docs/releases/


## 步骤
1. 安装 cert-manager
2. 安装 cert-manager-alidns-webhook
3. 配置证书

注意: 供应商的 Secret 只能放在 cert-manager 的 namespace 里面

## 完整部署步骤
```sh

cd k8s/infra-base/controllers/cert-manager

# 安装 cert-manager
helm upgrade --install \
  cert-manager oci://quay.io/jetstack/charts/cert-manager \
  --version v1.20.2 \
  --namespace cert-manager \
  --create-namespace \
  -f values.yaml

# 安装 alidns webhook
helm upgrade --install alidns-webhook cert-manager-alidns-webhook/alidns-webhook \
    --version 0.8.3 --namespace cert-manager -f cert-manager-alidns-webhook/values.yaml


# 配置云账号, 注意这个需要放在 cert-manager ns 内
kubectl apply -f certificate-chenwx/secret-crypto.yaml

# 创建集群证书签发器
kubectl apply -f certificate-chenwx/alidns-letsencrypt-clusterissuer.yaml

# 创建具体的证书申请 - 用户 ns 下面
kubectl apply -f certificate-chenwx/chenwx-certificate.yaml

# 合并操作
kubectl apply -k k8s/infra-base/controllers/certificate-chenwx

# 查看申请下来的证书
kubectl -n cwx get secrets chenwx-top-online-tls -o yaml

```


## 其它
```sh
helm show values oci://quay.io/jetstack/charts/cert-manager \
    --version v1.20.2 > defaultt-values.yaml

# letsencrypt 测试网证书申请
kubectl apply -f certificate-chenwx/staging/alidns-letsencrypt-staging-clusterissuer.yaml
kubectl apply -f certificate-chenwx/staging/chenwx-certificate-staging.yaml

```

## 证书内容
```sh
# 查看tls证书内容
kubectl -n cwx get secrets chenwx-top-online-tls -o yaml

kubectl -n cwx get secrets chenwx-top-online-tls -o jsonpath="{.data.tls\.crt}" | base64 -d
kubectl -n cwx get secrets chenwx-top-online-tls -o jsonpath="{.data.tls\.key}" | base64 -d

# 查看证书有效期
kubectl -n cwx get secrets chenwx-top-online-tls -o jsonpath="{.data.tls\.crt}" | base64 -d | openssl x509 -in /dev/stdin -noout -enddate

# 查看证书中包括的域名
kubectl -n cwx get secrets chenwx-top-online-tls -o jsonpath="{.data.tls\.crt}" | base64 -d | openssl x509 -in /dev/stdin -text -noout | grep -A1 "Subject Alternative Name"


# 导出证书
kubectl -n cwx get secret chenwx-top-online-tls -o jsonpath="{.data.tls\.crt}" | base64 -d > chenwx.top.crt
kubectl -n cwx get secret chenwx-top-online-tls -o jsonpath="{.data.tls\.key}" | base64 -d > chenwx.top.key

```

```sh

# 获取证书的公钥hash
openssl s_client -connect nacos.chenwx.top:443 -servername nacos.chenwx.top 2>&1 | openssl x509 -fingerprint -noout

# 获取证书支持的域名
openssl s_client -connect nacos.chenwx.top:443 -servername nacos.chenwx.top 2>&1 | openssl x509 -text -noout | grep -A1 "Subject Alternative Name"

```
