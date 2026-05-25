

## 修改项目 config.toml

[plugins.'io.containerd.cri.v1.images'.pinned_images]
    # sandbox = 'registry.k8s.io/pause:3.10'
    sandbox = 'harbor.chenwx.top/registry.k8s.io/pause:3.10'

[plugins.'io.containerd.cri.v1.runtime'.containerd.runtimes.runc.options]
    SystemdCgroup = true
