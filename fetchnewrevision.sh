#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"
IMAGE="$1"
TAG="$2"
PREFIX="$3"
CURRENT=$("$DIR"/hubcurlrevision.sh "$IMAGE" "$TAG")

if [ "x$CURRENT" == "xnull" ]; then
	if [ "x$PREFIX" != "x" ]; then
		echo "$PREFIX-1" 
	else
		echo 1
	fi
else
	if [ "x$PREFIX" == "x" ]; then
		echo $((CURRENT+1))
	else
		OLDPREFIX=$(echo "$CURRENT" | sed 's/^\(.*\)-[0-9]\+$/\1/')
		OLDREVSION=$(echo "$CURRENT" | sed 's/^.*-\([0-9]\)\+$/\1/')
		if [ "x$OLDPREFIX" != "$PREFIX" ]; then
			echo 1
		else
			echo $((OLDREVISION + 1))
		fi
	fi
fi
