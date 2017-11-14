#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"

. "$DIR"/common.sh

IMAGE=$(echo "$1" | sed 's/.*docker.io\///')
TAG="$2"

#echo Fetching fingerprint for image: $IMAGE

TOKEN=$(curl -s -L "https://auth.docker.io/token?service=registry.docker.io&scope=repository:$IMAGE:pull" | jq -r .token)

curl -s -L -H "Authorization: Bearer $TOKEN" "https://registry-1.docker.io/v2/$IMAGE/manifests/$TAG" | jq -r .history[0].v1Compatibility | jq -r '.container_config.Labels."com.github.kfox1111.fingerprint"'
