#!/bin/bash
set -e
revisionimage="$1"
finalimage="$2"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"
REVISION=$("$DIR/findrevision.sh" "$revisionimage")
docker build --build-arg image="$revisionimage" --build-arg revision="$REVISION" -t "$finalimage" -f $DIR/Dockerfile.revision "$DIR"
