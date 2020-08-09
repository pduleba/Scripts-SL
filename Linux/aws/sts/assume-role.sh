#!/usr/bin/env bash

function assume_role {
  echo "Role: " $1 "Name: " $2
  assume_output=$(aws sts assume-role --role-arn arn:aws:iam::906293011817:role/$1 --role-session-name $2)
  echo $assume_output
  access_key=$(echo $assume_output | jq -r '.Credentials.AccessKeyId')
  secret_access_key=$(echo $assume_output | jq -r '.Credentials.SecretAccessKey')
  session_token=$(echo $assume_output | jq -r '.Credentials.SessionToken')

 

  export AWS_ACCESS_KEY_ID=$access_key
  export AWS_SECRET_ACCESS_KEY=$secret_access_key
  export AWS_SESSION_TOKEN=$session_token
}