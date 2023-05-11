#!/usr/bin/env bash

OUTDIR="./public"

usage() { 
  echo "Usage: $0 -t <tag> -b <bucket>" 1>&2
  exit
}

clean() {
  rm -rf $OUTDIR
}

copy() {
  local id=$(docker create "$tag")
  docker cp $id:/var/www/html $OUTDIR
  docker rm -v $id
}

upload() {
  aws s3 sync $OUTDIR/. s3://$bucket --cache-control max-age=604800 --delete --size-only
}

invalidate() {
  distribution_id=$(aws cloudfront list-distributions --query "DistributionList.Items[?starts_with(Origins.Items[0].DomainName, '$bucket')].Id" --output text)
  aws cloudfront create-invalidation \
    --distribution-id $distribution_id \
    --paths "/*" \
    --query "Invalidation.Id" \
    --output text
}

while getopts "t:b:h" o; do
  case "${o}" in
    t) tag="$(echo "$OPTARG" | tr '[:upper:]' '[:lower:]')" ;;
    b) bucket="$(echo "$OPTARG" | tr '[:upper:]' '[:lower:]')" ;;
    h | *) usage ;;
  esac
done

[[ -z "$tag" || -z "$bucket" ]] && usage

clean && copy && upload && invalidate
