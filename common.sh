function jq () {
  docker run -i --rm devorbitus/ubuntu-bash-jq-curl jq "$@" 2>&1
}

