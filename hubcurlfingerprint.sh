#!/bin/bash
set -e

IMAGE=$(echo "$1" | sed 's/.*docker.io\///')
TAG="$2"

echo Fetching fingerprint for image: $IMAGE

alias jqc="docker run -i --rm devorbitus/ubuntu-bash-jq-curl jq"

TOKEN=$(curl -s -L "https://auth.docker.io/token?service=registry.docker.io&scope=repository:$IMAGE:pull" | jqc -r .token)

curl -s -L -H "Authorization: Bearer $TOKEN" "https://registry-1.docker.io/v2/$IMAGE/manifests/$TAG" | jqc -r .history[].v1Compatibility | jqc '.container_config.Labels."com.github.kfox1111.fingerprint"'
