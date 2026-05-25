
The is homeLab env

## 总览

**物理设备**
| 设备1   | 规格      |
| ------- | --------- |
| pve-1   | 8c64g2T   |
| pve-2   | 4c32g500G |
| cloud-1 | 2c4g40G   |
| cloud-2 | 2c4g40G   |

**逻辑架构**

物理平台: pve
基础设施: docker + k8s

**核心约束**
1. 严格限制只有2种部署方式, k8s和docker;
2. 公网只有1个入口, nginx;
3. 内网限制2个入口, k8s gateway 和 集群外的 traefix;
4. 除特殊应用外, 所有应用都放在集群内;
5. 结构IAC声明化, 减少过程式动作;


## 项目结构
```
ansible/            # play 任务
docker/             # 使用 docker-compose 部署在集群外的应用
terraform/          # terraform 管理的工程
```

## 关键应用

**集群外基础设施**
| name     | 备注                    |
| -------- | ----------------------- |
| pg       | metabase, harbor, Gatus |
| mysql    | gitea, grafana, Nacos   |
| redis    |                         |
| minio    | harbor                  |
| etcd     | k8s                     |
| gitea    |                         |
| smartdns |                         |
| samba    |                         |
| nfs      |                         |
| traefix  | (gitea,s3)              |
| harbor   |                         |


**业务应用**
| name | 备注                     |
| ---- | ------------------------ |
| blog | https://blog.chenwx.top |
| docs | https://docs.chenwx.top |


## 从0初始化步骤
1. 准备好pve系统, 获取root token
2. 部署minio, pg, gitea, nfs, etcd, vault 等基础服务
3. 部署 harbor, 准备好相关镜像
4. 制作虚拟机模板 pve-template-build-ub24.sh
5. 关键信息写入 vault
6. terraform 创建N个虚拟机
7. ansible 初始化主机, 并创建 k8s 集群
8. 集群内基础设施部署
9. 集群内应用部署, 通过 argocd 的 Set


## 其它事项
sealed-secrets 加密方式

```sh
kubeseal-file secret-plaintext.yaml
# or
kubeseal --scope namespace-wide --format yaml < file.yml > secret-crypto.yaml

```

deploy service
```sh
kubectl apply -k k8s/sets

```
