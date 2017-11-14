#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"
docker run -i --rm -v "$DIR/fingerprint.inner.sh":/fingerprint.sh --entrypoint /bin/sh "$1" -- -c /fingerprint.sh
