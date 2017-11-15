function setupjq () {
  docker pull devorbitus/ubuntu-bash-jq-curl
}

function jq () {
  docker run -i --rm devorbitus/ubuntu-bash-jq-curl jq "$@"
}

