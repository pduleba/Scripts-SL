#!/usr/bin/env bash

# Private parameters
DEFAULT_SCOPE=us
DEFAULT_PROFILE=default

handle_scope() {
  if [[ -z "${1}" ]] ; then
    cli_scope=${DEFAULT_SCOPE}
  else
    cli_scope=${1}
  fi
}

handle_profile() {
  if [[ -z "${1}" ]] ; then
    cli_profile=${DEFAULT_PROFILE}
  else
    cli_profile=${1}
  fi
}

configure() {
  # Validate input parameters and provide defaults if needed
  handle_scope ${1}
  handle_profile ${2}

  # Perform configuration - CLI
  #############################################
  if [[ "eu" == "${cli_scope}" ]] ; then
    cli_region=eu-central-1
  elif [[ "us" == "${cli_scope}" ]] ; then
    cli_region=us-east-1
  else
    echo "Invalid region '${cli_scope}'"
    exit 1
  fi

  # Perform configuration - Terraform
  #############################################
}


execute() {
  echo "AWS_REGION='${cli_region}' AWS_PROFILE='${cli_profile}'"
  echo "OK?"
  read approve

  eval 'unset AWS_REGION'
  eval 'unset AWS_PROFILE'

  eval 'export GIMME_AWS_CREDS_CRED_PROFILE=${cli_profile}'
  gimme-aws-creds --remember-device

  eval 'export AWS_REGION=${cli_region}'
  eval 'export AWS_PROFILE=${cli_profile}'
}


main() {
  configure ${1} ${2}

  execute
}


main ${1} ${2}
