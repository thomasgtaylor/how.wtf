#!/usr/bin/env bash

TERRAFORM=terraform -chdir="./terraform/env/$environment"

usage() { 
  echo "Usage: $0 <environment>" 1>&2
  exit
}

deploy() {
  $TERRAFORM init
  $TERRAFORM validate
	$TERRAFORM plan
	$TERRAFORM apply
}

destroy() {
	$TERRAFORM apply -destroy -auto-approve
}

environment="$1"
[[ -z "$environment" ]] && usage
deploy
