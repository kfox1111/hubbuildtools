#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"

. "$DIR"/common.sh

IMAGE=$(echo "$1" | sed 's/.*docker.io\///')
TAG="$2"

#echo Fetching revision for image: $IMAGE

REVISION=$(skopeo inspect "docker://$IMAGE:$TAG" | jq -r '.Labels."com.github.kfox1111.revision"')

if [ "x$REVISION" == "xnull" ]; then
	REVISION=$(skopeo inspect "docker://$IMAGE:$TAG" | jq -r '.Labels."com.github.kfox1111.revision"')
fi

if [ "x$REVISION" == "xnull" -o "x$REVISION" == "x" ]; then
	exit 1
fi

echo $REVISION
