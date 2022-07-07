#!/bin/bash

if [ -z "$1" ]; then
    echo "Argument <aldamex|napbiotec> is required!!!"
    exit 1
fi

PROFILE=$1
TAR_NAME=wp-content.old.tar

set -o allexport; source ".env-${PROFILE}.cfg"; set +o allexport
set -o allexport; source "config/${PROFILE}.cfg"; set +o allexport

#Copy wp-content from original container
sudo tar -cvf ${TAR_NAME} ${APP_PATH}/wp-content
