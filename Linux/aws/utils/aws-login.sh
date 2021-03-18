#!/usr/bin/env bash

# Private parameters
declare DEFAULT_ENVIRONMENT=dev
declare DEFAULT_PROFILE=default
declare DEFAULT_AREA=eu
declare DEFAULT_ROLE=role
declare DEFAULT_EU_REGION=eu-west-1
declare DEFAULT_EU_USER=user
declare DEFAULT_EU_HOST=host
declare DEFAULT_US_REGION=us-east-1
declare DEFAULT_US_USER=user
declare DEFAULT_US_HOST=host

declare -A AWS_EU_ENVIRONMENTS=(["exp"]="1" ["dev"]="2" ["prestage"]="3" ["stage"]="4" ["prod"]="5" ["shared"]="6")
declare -A AWS_US_ENVIRONMENTS=(["exp"]="1" ["dev"]="2" ["prestage"]="3" ["stage"]="4" ["prod"]="5" ["shared"]="6")


handle_environment_name() {
  if [[ -z "${1}" ]] ; then
    if [[ -n "${2}" ]] ; then
       environment_name=${2}
    else
       environment_name=${DEFAULT_ENVIRONMENT}
    fi
  else
    environment_name=${1}
  fi

  if [[ -z "${environment_name}" ]] ; then
    echo "Invalid environment name '${1}'"
    return 1
  fi
}


handle_account_id() {
  if [[ "eu" == "${1}" ]] ; then
    account_id=${AWS_EU_ENVIRONMENTS[${2}]}
  elif [[ "us" == "${1}" ]] ; then
    account_id=${AWS_US_ENVIRONMENTS[${2}]}
  else
    echo "Invalid area ${1}"
    return 1
  fi

  if [[ -z "${account_id}" ]] ; then
    echo "Account id not found by name '${2}'"
    return 1
  fi
}


configure() {
  awscli_ca_path=/Users/pduleba/workspace/documents/tp/ca.cert
  awscli_role_name=${DEFAULT_ROLE}

  if [[ -z "${1}" ]] ; then
    area=${DEFAULT_AREA}
  else
    area=${1}
  fi

  if [[ -z "${4}" ]] ; then
    awscli_profile=${DEFAULT_PROFILE}
  else
    awscli_profile=${4}
  fi

  if [[ "eu" == "${area}" ]] ; then
    awscli_region=${DEFAULT_EU_REGION}
    awscli_username=${DEFAULT_EU_USER}
    awscli_host=${DEFAULT_EU_HOST}
  elif [[ "us" == "${area}" ]] ; then
    awscli_region=${DEFAULT_US_REGION}
    awscli_username=${DEFAULT_US_USER}
    awscli_host=${DEFAULT_US_HOST}
  else
    echo "Invalid area ${area}"
    exit 1
  fi


  handle_environment_name "${2}"
  awscli_environment_name=${environment_name}
  handle_account_id "${area}" "${awscli_environment_name}"
  awscli_account_id=${account_id}

  handle_environment_name "${3}" "${2}"
  project_environment_name=${environment_name}
  handle_account_id "${area}" "${project_environment_name}"
  project_account_id=${account_id}
}

execute() {
  echo -e "AWS CLI (\e[31m${awscli_environment_name}=${awscli_account_id}\e[0m) on (\e[31m${area}\e[0m) :: profile=\e[32m${awscli_profile}\e[0m role=\e[32m${awscli_role_name}\e[0m"
  echo -e "Project (\e[31m${project_environment_name}=${project_account_id}\e[0m) on (\e[31m${area}\e[0m) :: ENVIRONMENT=\e[32m${project_environment_name}\e[0m TF_VAR_target_account_id=\e[32m${project_account_id}\e[0m"
  echo -e "\e[32mOK?\e[0m"
  read -r

  eval 'unset AWS_PROFILE'
  eval 'unset AWS_REGION'
  eval 'unset ENVIRONMENT'

  echo "In progress..."
  username="${awscli_username}" \
  aws-adfs login \
  --ssl-verification \
  --adfs-ca-bundle "${awscli_ca_path}" \
  --adfs-host "${awscli_host}" \
  --role-arn "arn:aws:iam::${awscli_account_id}:role/${awscli_role_name}" \
  --profile "${awscli_profile}" \
  --region "${awscli_region}"

  # AWS CLI related variables
  eval "export AWS_PROFILE=${awscli_profile}"
  eval "export AWS_REGION=${awscli_region}"
  # Project related variables
  eval "export ENVIRONMENT=${project_environment_name}"
  eval "export TF_VAR_target_account_id=${project_account_id}"
}

main() {
  configure "${1}" "${2}" "${3}" "${4}"
  execute
}

main "${1}" "${2}" "${3}" "${4}"
