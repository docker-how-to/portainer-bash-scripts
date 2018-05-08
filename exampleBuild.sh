#!/usr/bin/env bash
IMAGE_NAME="docker-how-to/portainer-bash-scripts"
docker build --pull --rm -t ${IMAGE_NAME} .
