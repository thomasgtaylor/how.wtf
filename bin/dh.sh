#!/usr/bin/env bash

usage() { 
  echo "Usage: $0 -t <tag> [-b build] [-r run] [-p publish] [-h help]" 1>&2
  exit
}

build() {
  local image="$1"
  docker build . -t $image
}

run() {
  local image="$1"
  docker run -it --rm --init -p 1313:1313 $image
}

while getopts "t:brh" o; do
  case "${o}" in
    t) tag="$(echo "$OPTARG" | tr '[:upper:]' '[:lower:]')" ;;
    b) build=true ;;
    r) run=true ;;
    h | *) usage ;;
  esac
done

[[ -z "$tag" ]] && usage
[[ "$build" ]] && build "$tag"
[[ "$run" ]] && run "$tag"

exit 0
