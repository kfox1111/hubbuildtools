#!/bin/bash -e

# This script takes in a docker registry dump located in $(pwd)/registry
# and outputs a quine script and data file in it.
# Env:
# * set REGNAME to the registry name that the quine registry will be loaded into. Default
#   library/registry

REGNAME=${REGNAME:=library/registry}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"
. $DIR/common.sh

rm -rf rawdata/
mkdir -p rawdata

tar -cvf rawdata/registry.tar registry

#Not sure how this is generated? Just making a random persistent number....
CONTAINERID=$(openssl rand -hex 32)

cat > rawdata/settings <<EOF
CONTAINERID=$CONTAINERID
REGNAME=$REGNAME
EOF

MANIFEST=$(cat registry/docker/registry/v2/repositories/$REGNAME/_manifests/tags/latest/current/link | sed 's/sha256://')
MANIFEST2PARENT="registry/v2/blobs/sha256/$(echo $MANIFEST | cut -c1-2)/$MANIFEST/data"
PARENTSHA=$(jq -r '.config.digest' registry/docker/$MANIFEST2PARENT | sed 's/^sha256://')
PARENTPREFIX=$(echo $PARENTSHA | cut -c1-2)
MANIFESTPARENT=registry/v2/blobs/sha256/$PARENTPREFIX/$PARENTSHA/data
#DIRROOT="/var/lib/registry/docker"
DIRROOT=""
DIRPREFIX="$DIRROOT/registry/v2/repositories/$REGNAME"

jq -c '.config.container_config.image="sha256:'$PARENTSHA'" | .container_config.Cmd=["/bin/sh", "-c", "#(nop) ADD multi:foo in / "] | .container_config.Image="sha256:'$PARENTSHA'" | .history += [{"created": "2017-11-29T15:29:13.963036127Z","created_by":"/bin/sh -c #(nop) ADD multi:foo in / "}] | .rootfs.diff_ids += ["sha256:@DATASHA@"]' registry/docker/$MANIFESTPARENT > rawdata/manifest1.json.tmpl

jq '.layers+=[{"mediaType":"application/vnd.docker.image.rootfs.diff.tar.gzip","size":"@DIFFSIZE@","digest":"sha256:@DIFFSHA@"}] | .config.size="@MANIFESTSIZE@" | .config.digest = "sha256:@MANIFESTSUM@"' registry/docker/$MANIFEST2PARENT > rawdata/manifest2.json.tmpl

rm -f data | true
tar -cvf data rawdata
cp -a $DIR/quine .
