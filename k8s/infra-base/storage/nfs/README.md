
方式1: 多个 pv(不同子路径) + pvc

方式2: 一个 pv和pvc, Deployment 挂载时使用 subPath 访问自己的子目录
    注意, 不会自动创建子目录

方式3: 使用 subPathExpr 动态创建子目录


```yaml
# service-b-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: service-b
  namespace: service-b
spec:
  replicas: 1
  selector:
    matchLabels:
      app: service-b
  template:
    metadata:
      labels:
        app: service-b
    spec:
      containers:
      - name: app
        image: your-image:latest
        volumeMounts:
        - name: nfs-data
          mountPath: /data
          subPath: a2           # 固定子路径名称 a2

        - name: nfs-data
          mountPath: /data
          subPathExpr: $(POD_NAME)  # 动态子路径

      volumes:
      - name: nfs-data
        persistentVolumeClaim:
          claimName: service-b-pvc
```
