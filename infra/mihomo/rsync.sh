#!/bin/bash

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $WORK_DIR

TARGET_HOST="h253"

rsync -avuP ./config.yaml root@${TARGET_HOST}:/etc/mihomo/config.yaml

ssh root@${TARGET_HOST} 'systemctl restart mihomo.service'
