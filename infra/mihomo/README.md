
## 简单使用方式

```sh
export HTTPS_PROXY=http://192.168.5.253:7890
export HTTP_PROXY=http://192.168.5.253:7890
export ALL_PROXY=socks5://192.168.5.253:7890
export NO_PROXY="localhost,127.0.0.1,192.168.5.0/16,.chenwx.top"
```

## 透明代理
将网关指向 192.168.5.253

## dns 分流
将网关和dns服务器都指向 192.168.5.253
