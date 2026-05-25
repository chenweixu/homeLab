#!/bin/bash

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $WORK_DIR

TARGET_HOST="pve-1"
TARGET_DIR="/home/wait/docker/"

rsync -avuP --exclude="rsync.sh" ./ ${TARGET_HOST}:$TARGET_DIR


ssh ${TARGET_HOST} 'COMPOSE_FILE=/home/wait/docker/smartDNS/docker-compose.yml docker compose restart'
