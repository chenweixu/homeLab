
## minio
```sh
# 创建桶, 开启版本控制和对象锁
mc mb --with-versioning --with-lock local/terraform
mc encrypt set sse-s3 local/terraform
```

## terraform cmd

```sh
terraform init
terraform init -backend-config=backend-config.tfvars

terraform plan

terraform apply

# 迁移数据源
terraform init -migrate-state
terraform init -migrate-state -backend-config=backend-config.tfvars

# 串行化执行, 避免单个 pve 主机创建多实例时, 克隆系统时文件锁超时不释放的问题
terraform apply -parallelism=1

# 销毁全部资源
terraform destroy --auto-approve

# 刷新 output 信息
terraform apply -refresh-only

# 删除资源, 保留本地代码
terraform destroy -target='proxmox_virtual_environment_vm.this'
terraform destroy -target='module.vm_k8s_nodes'


```
