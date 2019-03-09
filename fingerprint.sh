#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"

container="$1"
cleanup=0

if [ "x$AUTO_PREFIX" == "xrpmrepo-version" -o "x$AUTO_PREFIX" == "xrpmrepo-version-release" ]; then
	cleanup=1
	docker build --build-arg image="$container" -t "fingerprint.$$" "$DIR/Dockerfile.fingerprinthelper"
	container="fingerprint.$$"
fi

docker run -i --rm -v "$DIR/fingerprint.inner.sh":/fingerprint.sh --entrypoint /bin/sh "$container" /fingerprint.sh | bzip2 -c| base64 | tr '\n' '=' | sed 's/=//g'

if [ $cleanup == 1 ]; then
	docker rmi "$container"
fi
