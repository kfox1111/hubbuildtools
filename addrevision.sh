#!/bin/bash
set -e
REVISIONIMAGE="$1"
IMAGE="$2"
TAG="$3"
FINALIMAGE="$4"
PREFIX="$5"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"
REVISION=$("$DIR/fetchnewrevision.sh" "$IMAGE" "$TAG" "$PREFIX")
docker build --build-arg image="$REVISIONIMAGE" --build-arg revision="$REVISION" -t "$FINALIMAGE" -f $DIR/Dockerfile.revision "$DIR"
