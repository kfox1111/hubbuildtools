#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"

. "$DIR"/common.sh

LOCALIMAGE="$1"
REVISION=$(docker inspect "$LOCALIMAGE" | jq -r '.[].ContainerConfig.Labels."com.github.kfox1111.revision"')
if [ "x$REVISION" == "xnull" ]; then
	REVISION=$(docker inspect "$LOCALIMAGE" | jq -r '.[].Config.Labels."com.github.kfox1111.revision"')
fi
if [ "x$REVISION" == "xnull" ]; then
	echo Failed to fetch revision >&2
	exit -1
fi
echo $REVISION
