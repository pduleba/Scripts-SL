#!/usr/bin/env bash

if [[ -z "$1" ]]
then
    echo Filename is needed
fi

gpg --import ~/workspace/documents/encryption/keys/private.gpg
gpg -e --armor --recipient merchant1@st.com $1