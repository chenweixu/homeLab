
```sh
# test
ansible all -m ping -u ubuntu --private-key ../keys/ssh/cwx_id_ed25519

# 查看待执行任务列表
ansible-playbook playbook.yml --list-tasks

```

## k8s 新增节点
```sh
kubeadm token list

kubeadm token create --print-join-command

kubeadm join 192.168.5.22:6443 --token v2jb9i.kzytqjxy3i18dhbj --discovery-token-ca-cert-hash sha256:6e104c8b9b24ee8a34157dcbb7f83d484a5e46ef7a46a57832b5a6a5f6054c5a

```

清理节点
```sh
kubeadm reset -f
rm -rf /etc/kubernetes/* /var/lib/kubelet/* /etc/cni/net.d
```


```sh
# 处理网卡问题
kubectl edit cm -n kube-system cilium-config
  l2-pod-announcements-interface-pattern: enp6s18,eth0
  devices: enp+,eth+
```
