#!/bin/bash

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $WORK_DIR


kubectl -n cwx get secret chenwx-top-online-tls -o jsonpath="{.data.tls\.key}" | base64 -d > chenwx.top.key
kubectl -n cwx get secret chenwx-top-online-tls -o jsonpath="{.data.tls\.crt}" | base64 -d > chenwx.top.crt

scp chenwx.top.* h8:~/docker/traefik/ssl/
scp chenwx.top.* pve-1:~/docker/traefik/ssl/
scp chenwx.top.* ecs:~/docker/nginx/cert/

rm chenwx.top.*
