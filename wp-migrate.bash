#!/bin/bash

if [ -z "$1" ]; then
    echo "Argument <aldamex|napbiotec> is required!!!"
    exit 1
fi

PWD=$(pwd)
PROFILE=$1
TAR_NAME="${PWD}/wp-content.original.tar"

set -o allexport; source ".env-${PROFILE}.cfg"; set +o allexport
set -o allexport; source "configs/${PROFILE}.cfg"; set +o allexport

#Copy wp-content from original container
cd ${APP_PATH}
sudo tar -cvf ${TAR_NAME} wp-content
cd ${PWD}
