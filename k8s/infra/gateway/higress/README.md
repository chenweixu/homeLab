

## Kustomization 安装
```sh
kubectl apply -k
kubectl kustomize --enable-helm k8s/services_admin/higress | kubectl apply -f -
```


## helm 本地安装

```sh
helm repo add higress.io https://higress.io/helm-charts
helm repo update
helm search repo higress

wait@ub05:~$ helm search repo higress
NAME                            CHART VERSION   APP VERSION     DESCRIPTION
higress.io/higress              2.2.0           2.2.0           Helm chart for deploying Higress gateways
higress.io/higress-console      2.2.1           2.2.1           Management console for Higress
higress.io/higress-core         2.2.0           2.2.0           Helm chart for deploying higress gateways
higress.io/higress-local        0.6.1           0.6.1           Helm chart for deploying higress gateways
higress.io/istio                1.12.4          1.12.4          Helm chart for deploying higress istio
higress.io/istio-local          1.12.4          1.12.4          Helm chart for deploying higress istio


helm pull higress.io/higress


helm install higress higress.io/higress -n higress-system --create-namespace \
  -f k8s/base_services/higress/values.yaml


helm upgrade higress higress.io/higress -n higress-system \
  -f k8s/base_services/higress/values.yaml


wait@ub05:~$ kubectl -n higress-system get pod
NAME                                  READY   STATUS    RESTARTS   AGE
higress-console-55bc6cb498-dqddh      1/1     Running   0          51s
higress-controller-5f6bffc79d-chhh7   2/2     Running   0          51s
higress-gateway-6944d65ffc-xkkcm      1/1     Running   0          51s

wait@ub05:~$ kubectl -n higress-system get svc
NAME                 TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)                                                             AGE
higress-console      ClusterIP      10.11.78.217    <none>         8080/TCP                                                            18m
higress-controller   ClusterIP      10.11.210.149   <none>         8888/TCP,8889/TCP,15051/TCP,15010/TCP,15012/TCP,443/TCP,15014/TCP   18m
higress-gateway      LoadBalancer   10.11.126.217   192.168.5.31   80:30953/TCP,443:32754/TCP                                          85s

kubectl -n higress-system get svc/higress-gateway -o jsonpath='{.status.conditions}' | jq
[
  {
    "lastTransitionTime": "2026-03-27T11:06:40Z",
    "message": "",
    "reason": "satisfied",
    "status": "True",
    "type": "cilium.io/IPAMRequestSatisfied"
  }
]

# 显示租约
wait@ub05:~$ kubectl -n kube-system get lease | grep "l2announce"
cilium-l2announce-cwx-traefik                      h23          234d
cilium-l2announce-higress-system-higress-gateway   h21          13m

# 显示ui
hgctl dashboard console

```
