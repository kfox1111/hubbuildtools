#!/bin/bash -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"

container="$1"
cleanup=0

if [ "x$AUTO_PREFIX" == "xrpmrepo-version" -o "x$AUTO_PREFIX" == "xrpmrepo-version-release" -o "x$AUTO_PREFIX" == "xfilecontent" ]; then
	cleanup=1
	docker build --build-arg image="$container" -t "fingerprint.$$" -f "$DIR/Dockerfile.fingerprinthelper" "$DIR" > /dev/null
	container="fingerprint.$$"
fi

docker run -i --rm -v "$DIR/fingerprint.inner.sh":/fingerprint.sh --entrypoint /bin/sh "$container" /fingerprint.sh | bzip2 -c| base64 | tr '\n' '=' | sed 's/=//g'

if [ $cleanup == 1 ]; then
	docker rmi "$container" > /dev/null
fi
