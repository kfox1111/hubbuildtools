#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"

IMAGE="$1"
TAG="$2"
FINGERPRINT="$3"

OFP=$($DIR/hubcurlfingerprint.sh "$IMAGE" "$TAG")

#If failed to get fingerprint, treat it as the same.
if [ "x$OFP" != "x$FINGERPRINT" -a "x$OFP" != "x" ]; then
	echo "Fingerprints differ: $OFP != $FINGERPRINT"
	exit 0
fi
echo Fingerprints are the same.
exit 1
