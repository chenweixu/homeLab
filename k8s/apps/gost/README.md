
用于集群内代理控制

```sh
export HTTPS_PROXY=http://gost:80
export HTTP_PROXY=http://gost:80
export ALL_PROXY=socks5://gost:80
export NO_PROXY="localhost,127.0.0.1,10.11.0.0/16,10.12.0.0/16,192.168.5.0/16,192.168.0.0/16,.cluster.local,.svc,.svc.cluster.local,kubernetes.default.svc.cluster.local,.chenwx.top"
```
