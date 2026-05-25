#!/bin/bash

# apt install libguestfs-tools
#===================================================================

# 制作 pve 厚镜像

TEMPLATE_NAME="template-ubuntu-2404-v2"

IMAGE_FILE_NAME="ubuntu-24.04-thick.qcow2"

TAGS="template;ubuntu24.04;cloud-init"

SOURCE_URL="http://files.chenwx.top/soft/noble-server-cloudimg-amd64.img"

# VM_ID=9000
VM_ID=$(pvesh get /cluster/nextid)

echo "current TEMPLATE_NAME: ${VM_ID}"

STORAGE="local-lvm"

#===================================================================
# 检查包是否存在
if ! dpkg -l | grep -q "libguestfs-tools"; then
    echo "安装 libguestfs-tools..."
    sudo apt update && sudo apt install -y libguestfs-tools || { echo "安装失败"; exit 1; }
else
    echo "libguestfs-tools 已安装, skip"
fi
#===================================================================


# 1. 下载原始镜像
if [ ! -f "original.img" ]; then
    wget $SOURCE_URL -O original.img
fi

# 2. 复制一份进行定制
cp original.img $IMAGE_FILE_NAME

# 3. 核心定制: 注入软件和配置
# --install: 安装必要的 agent
# --run-command: 换源
# --firstboot-command: 确保第一次开机时执行的任务
# 第一次改源是构建期间使用, 第二次是为了生成 cloud-init 任务模板

virt-customize -a $IMAGE_FILE_NAME \
    --run-command 'cat > /etc/apt/sources.list.d/ubuntu.sources <<EOF
Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu/
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu/
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF' \
    --run-command "apt-get update || true" \
    --run-command "apt-get install -y --no-install-recommends qemu-guest-agent net-tools vim curl" \
    --run-command "systemctl enable qemu-guest-agent" \
    --run-command 'cat > /etc/cloud/cloud.cfg.d/99-custom-mirror.cfg <<EOF
apt:
  preserve_sources_list: false
  primary:
    - arches: [default]
      uri: https://mirrors.tuna.tsinghua.edu.cn/ubuntu/
  security:
    - arches: [default]
      uri: https://mirrors.tuna.tsinghua.edu.cn/ubuntu/
EOF' \
    --run-command "cloud-init clean --logs"

echo "厚镜像制作完成: $IMAGE_FILE_NAME"



qm create $VM_ID --name ${TEMPLATE_NAME} \
    --cpu host \
    --sockets 1 \
    --cores 2 \
    --memory 1024 \
    --machine q35 \
    --bios ovmf \
    --net0 virtio,bridge=vmbr0 \
    --tags "$TAGS"

qm importdisk $VM_ID ${IMAGE_FILE_NAME} $STORAGE

qm set $VM_ID \
    --efidisk0 $STORAGE:4,format=raw,pre-enrolled-keys=1 \
    --scsihw virtio-scsi-single \
    --scsi0 $STORAGE:vm-$VM_ID-disk-0,iothread=1,aio=io_uring \
    --boot order=scsi0 \
    --serial0 socket \
    --ostype l26 \
    --vga serial0 \
    --keyboard en-us \
    --ide2 $STORAGE:cloudinit \
    --agent 1,type=virtio

qm template $VM_ID


rm -rf $IMAGE_FILE_NAME
rm -rf original.img
