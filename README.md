

## 项目结构
``
terraform/          # terraform 管理的工程
```


sealed-secrets 加密方式

```sh
kubeseal-file secret-plaintext.yaml
# or
kubeseal --scope namespace-wide --format yaml < file.yml > secret-crypto.yaml

```
