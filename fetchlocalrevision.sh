#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"

. "$DIR"/common.sh

LOCALIMAGE="$1"
docker inspect "$LOCALIMAGE" | jq -r '.[].ContainerConfig.Labels."com.github.kfox1111.revision"'
