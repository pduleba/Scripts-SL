#!/bin/bash

# globally /etc/environment (all users)
PATH = /usr/local/sbin:/usr/local/bin:/PATH_TO_BE_ADDED
source /etc/environment && export PATH

# locally ~/.profile (current user)
# add this command to `~/.profile` file
export PATH=$PATH:/myNewDir
# re-load ~/.profile by running the source command
source ~/.profile