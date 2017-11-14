#!/bin/bash
set -e
fingerprintimage="$1"
finalimage="$2"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"
FINGERPRINT=$("$DIR/fingerprint.sh" "$fingerprintimage")
docker build --build-arg image="$fingerprintimage" --build-arg fingerprint="$FINGERPRINT" "$DIR" -t "$finalimage" -f $DIR/Dockerfile.fingerprint
