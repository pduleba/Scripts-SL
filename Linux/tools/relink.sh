#!/usr/bin/env bash

# parameters
declare -r BIN_PATH="/usr/local/bin/custom"

function execute() {
  local lookup_path=""
  local gnu_command=""
  local link_command=""

  if [[ -z "${1}" ]] ; then
    echo "Path argument is required"
    return 1
  else
    if [[ -d "${1}" ]] ; then
      lookup_path="${1}"
    else
      echo "Path '${1}' needs to be directory"
      return 1
    fi
  fi


  for source_path in $(find "${lookup_path}" -maxdepth 1 -type l -o -type f -not -path '*/\.*' | sort)
  do
    gnu_command=$(basename "${source_path}")
    if [[ -z "${gnu_command}" ]] ; then
      echo "Unable to extract base name from '${source_path}'"
      return 1
    else
      link_command="ln -si ${source_path} ${BIN_PATH}/${gnu_command}"
      echo -e "link_command (\e[31m${link_command}\e[0m)"
      echo -e "\e[32mOK?\e[0m"
      read -r

      eval "${link_command}"
      echo -e "\e[32mDONE!\e[0m"
    fi
  done
}

execute "${1}"