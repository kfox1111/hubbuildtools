#!/bin/bash
set -e
IMAGE="$1"
TAG="$2"
FINALIMAGE="$3"
PREFIX="$4"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"
REVISION=$("$DIR/fetchnewrevision.sh" "$IMAGE" "$TAG" "$prefix")
docker build --build-arg image="$revisionimage" --build-arg revision="$REVISION" -t "$FINALIMAGE" -f $DIR/Dockerfile.revision "$DIR"
