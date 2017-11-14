#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"
docker run -i --rm -v "$DIR/fingerprint.inner.sh":/fingerprint.sh --entrypoint /fingerprint.sh "$1"
