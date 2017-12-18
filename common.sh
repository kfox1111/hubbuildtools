function setupjq () {
  docker pull devorbitus/ubuntu-bash-jq-curl
}

function setupxmlstarlet () {
  docker pull jakubsacha/docker-xmlstarlet
}

function jq () {
  docker run -i --rm devorbitus/ubuntu-bash-jq-curl jq "$@"
}

function xmlstarlet () {
  docker run -i --rm jakubsacha/docker-xmlstarlet "$@"
}

function startregistry () {
  NAME=registry
  PORT=5000
  docker run -d -p $PORT:5000 -v $(pwd)/registry:/var/lib/registry --name $NAME registry
}

function buildregistry () {
  NAME=registry
  IMAGE=library/registry
  PORT=5000
  docker pull registry
  docker tag $IMAGE localhost:$PORT/$REGNAME
  end=$(date +%s)
  end=$((end + 180)) #2 min
  set +xe
  while true; do
    sleep 5
    #The registry is not always emediately ready. Try for a bit to get it.
    #FIXME what prefix to use? we need it to be unique in the registry....
    docker push localhost:$PORT/$REGNAME
    [ $? -eq 0 ] && break
    now=$(date +%s)
    [ $now -gt $end ] && echo failed to start container && docker logs $NAME && exit -1
  done
  set -xe
}

function stopregistry() {
  NAME=registry
  docker rm -f $NAME
}
