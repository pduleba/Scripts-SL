#!/usr/bin/env bash

declare -A AWS_EU_ACCOUNTS=(["exp"]="1" ["dev"]="2" ["prestage"]="3" ["stage"]="4" ["prod"]="5" ["shared"]="6")
declare -A AWS_US_ACCOUNTS=(["exp"]="1" ["dev"]="2" ["prestage"]="3" ["stage"]="4" ["prod"]="5" ["shared"]="6")

configure() {
  awscli_ca_path=/home/pduleba/workspace/documents/cert/ca.cert
  awscli_role_name=RootRole

  target_assume_role=deployer/role
  target_project_version=pduleba

  if [[ -z "$1" ]] ; then
    target=eu
  else
    target=$1
  fi

  if [[ -z "$2" ]] ; then
    awscli_profile=default
  else
    awscli_profile=$2
  fi

  if [[ "eu" == "$target" ]] ; then
    awscli_region=eu-west-1
    awscli_username=pduleba@ad.main.info
    awscli_host=adfs.ad.main.info
  elif [[ "us" == "$target" ]] ; then
    awscli_region=us-east-1
    awscli_username=pduleba
    awscli_host=adfs.ad.usa.main.info
  else
    echo "Invalid target $target"
    exit 1
  fi
}

set_account_name() {
  if [[ -z "$1" ]] ; then
    if [[ ! -z "$2" ]] ; then
       account_name=$2
    else
       account_name=dev
    fi
  else
    account_name=$1
  fi

  if [[ -z "$account_name" ]] ; then
    echo "Invalid account name '$1'"
    return 1
  fi
}

set_account_id() {
  if [[ "eu" == "$1" ]] ; then
    account_id=${AWS_EU_ACCOUNTS[$2]}
  elif [[ "us" == "$1" ]] ; then
    account_id=${AWS_US_ACCOUNTS[$2]}
  else
    echo "Invalid target $1"
    return 1
  fi

  if [[ -z "$account_id" ]] ; then
    echo "Account id not found by name '$2'"
    return 1
  fi
}

execute() {
  echo -e "AWS CLI   (\e[31m$awscli_account=$awscli_account_id\e[0m) on (\e[31m$target\e[0m) :: profile \e[32m$awscli_profile\e[0m role \e[32m$awscli_role_name\e[0m"
  echo -e "Terraform (\e[31m$target_account=$target_account_id\e[0m) on (\e[31m$target\e[0m) :: assume_role \e[32m$target_assume_role\e[0m project_version \e[32m$target_project_version\e[0m"
  echo -e "\e[5mOK?\e[0m"
  read approve

  eval 'unset AWS_PROFILE'
  eval 'unset AWS_REGION'

  echo "In progress..."
  username="${awscli_username}" \
  aws-adfs login \
  --ssl-verification \
  --adfs-ca-bundle $awscli_ca_path \
  --env \
  --adfs-host $awscli_host \
  --role-arn arn:aws:iam::$awscli_account_id:role/$awscli_role_name \
  --profile $awscli_profile \
  --region $awscli_region

  eval 'export AWS_PROFILE=$awscli_profile'
  eval 'export AWS_REGION=$awscli_region'
  eval 'export ENVIRONMENT=$account_name'
}

main() {
  configure $1 $4

  set_account_name $2
  awscli_account=$account_name
  set_account_id $target $account_name
  awscli_account_id=$account_id

  set_account_name $3 $2
  target_account=$account_name
  set_account_id $target $account_name
  target_account_id=$account_id

  execute
}

main $1 $2 $3 $4
