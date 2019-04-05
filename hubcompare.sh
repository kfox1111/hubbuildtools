#!/bin/bash
set -e

if [ "x$NEW_BUILD" != "x" ]; then
	echo Forcing new build. Skipping fingerprint compare.
	exit 0
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"

. "$DIR"/common.sh

IMAGE="$1"
TAG="$2"
LOCALIMAGE="$3"
FINGERPRINT=$(docker inspect "$LOCALIMAGE" | jq -r '.[].ContainerConfig.Labels."com.github.kfox1111.fingerprint"')
if [ "x$FINGERPRINT" == "xnull" ]; then
	# Docker changed where this lives in a newer version. :(
	FINGERPRINT=$(docker inspect "$LOCALIMAGE" | jq -r '.[].Config.Labels."com.github.kfox1111.fingerprint"')
fi

OFP=$($DIR/hubcurlfingerprint.sh "$IMAGE" "$TAG")

#If failed to get fingerprint, treat it as the same.
if [ "x$OFP" != "x$FINGERPRINT" -a "x$OFP" != "x" ]; then
	echo "Fingerprints differ: $OFP != $FINGERPRINT"
	exit 0
fi
echo Fingerprints are the same.
exit 1
