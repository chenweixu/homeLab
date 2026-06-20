
项目地址
```https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner/deploy```



## nfs 服务器导出
```conf
/data/nfs-csi 192.168.5.21(rw,async,no_subtree_check,no_all_squash,anonuid=1000,anongid=1000)
/data/nfs-csi 192.168.5.22(rw,async,no_subtree_check,no_all_squash,anonuid=1000,anongid=1000)
/data/nfs-csi 192.168.5.23(rw,async,no_subtree_check,no_all_squash,anonuid=1000,anongid=1000)

exportfs -a
```

## 客户端主机安装

```sh
sudo apt install nfs-common

showmount -e 192.168.5.9

```


## helm

```sh
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=x.x.x.x \
    --set nfs.path=/exported/path
```

注意 nfs provisioner 映射的用户为 65534:65534
需要此用户能在 nfs 上创建目录, 权限默认为 777


## Parameters
onDelete
    如果是保留, 则会被改名为 archived-<volume.Name>

archiveOnDelete
    如果 onDelete 存在, 则会忽略 archiveOnDelete

pathPattern
    指定用于通过 PVC 元数据(如标签, 注释, 名称或命名空间)创建目录路径的模板;
    要指定元数据, 请使用 ${.PVC.<metadata>};
    例如: 如果文件夹应命名为 <pvc-namespace>-<pvc-name>, 则使用 ${.PVC.namespace}-${.PVC.name} 作为 pathPattern;

    默认参数为: ${namespace}-${pvcName}-${pvName}
    cwx-my-pvc-pvc-25e950f6-9214-4d4f-9f65-689c3b17633c


注意:
pv 是不限命名空间的集群资源, 即全局可见
但是 pvc 是限制命名空间的


管理
```sh
# 查看授权
kubectl get sa

# 查看存储类
kubectl get sc
kubectl get pvc
kubectl get pv


# 实际容器内挂载路径
10.2.1.5:/data/public_nfs/default-my-pvc-pvc-ee5d090a-c921-45a1-be89-77abb5c59568

cwx-my-pvc-pvc-25e950f6-9214-4d4f-9f65-689c3b17633c


[wait@wait-fedora nfs]$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM            STORAGECLASS   REASON   AGE
pvc-ee5d090a-c921-45a1-be89-77abb5c59568   1Gi        RWO            Retain           Bound    default/my-pvc   nfs-client              7m26s

[wait@wait-fedora nfs]$ kubectl get pvc
NAME     STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
my-pvc   Bound    pvc-ee5d090a-c921-45a1-be89-77abb5c59568   1Gi        RWO            nfs-client     9m31s

[wait@wait-fedora nfs]$ kubectl get pv -n cwx
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM            STORAGECLASS   REASON   AGE
pvc-25e950f6-9214-4d4f-9f65-689c3b17633c   1Gi        RWO            Retain           Bound      cwx/my-pvc       nfs-client              93s
pvc-ee5d090a-c921-45a1-be89-77abb5c59568   1Gi        RWO            Retain           Released   default/my-pvc   nfs-client              11m
```
