#!/bin/bash

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $WORK_DIR

TARGET_HOST="ecs"
TARGET_DIR="/home/wait/docker/"

rsync -avuP --exclude="rsync.sh" ./nginx ${TARGET_HOST}:$TARGET_DIR

ssh ${TARGET_HOST} 'COMPOSE_FILE=/home/wait/docker/nginx/docker-compose.yaml docker compose exec nginx nginx -s reload'
