#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"

. "$DIR"/common.sh

IMAGE=$(echo "$1" | sed 's/.*docker.io\///')
TAG="$2"

#echo Fetching fingerprint for image: $IMAGE

FINGERPRINT=$(skopeo inspect "docker://$IMAGE:$TAG" | jq -r '.Labels."com.github.kfox1111.fingerprint"')

if [ "x$FINGERPRINT" == "xnull" -o "x$FINGERPRINT" == "x" ]; then
	FINGERPRINT=$(skopeo inspect "docker://$IMAGE:$TAG" | jq -r '.Labels."com.github.kfox1111.fingerprint"')
	#FINGERPRINT=$(curl -s -L -H "Authorization: Bearer $TOKEN" "https://registry-1.docker.io/v2/$IMAGE/manifests/$TAG" | jq -r .history[0]) #.v1Compatibility | jq -r '.config') #.Labels."com.github.kfox1111.fingerprint"')
fi

if [ "x$FINGERPRINT" == "xnull" -o "x$FINGERPRINT" == "x" ]; then
	exit 1
fi
echo $FINGERPRINT
