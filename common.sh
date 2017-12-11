function setupjq () {
  docker pull devorbitus/ubuntu-bash-jq-curl
}

function jq () {
  docker run -i --rm devorbitus/ubuntu-bash-jq-curl jq "$@"
}

function startregistry () {
  NAME=registry-$$
  PORT=5000
  docker run -d -p $PORT:5000 -v $(pwd)/registry:/var/lib/registry --name $NAME registry
}

function buildregistry () {
  IMAGE=registry
  FINALIMAGE=library/registry
  docker pull registry
  docker tag $IMAGE localhost:$PORT/$FINALIMAGE
  docker push localhost:$PORT/$FINALIMAGE
}

function stopregistry() {
  NAME=registry-$$
  docker rm -f $NAME
}
