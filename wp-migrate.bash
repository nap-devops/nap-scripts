#!/bin/bash

if [ -z "$1" ]; then
    echo "Argument <aldamex|napbiotec> is required!!!"
    exit 1
fi

PWD=$(pwd)
PROFILE=$1
TAR_NAME="${PWD}/wp-content.original.tar"
DUMPED_FILE="${PWD}/${PROFILE}.dump.sql"

set -o allexport; source ".env-${PROFILE}.cfg"; set +o allexport
set -o allexport; source "configs/${PROFILE}.cfg"; set +o allexport

#Tar wp-content from original container
cd ${APP_PATH}
sudo tar -cvf ${TAR_NAME} wp-content
cd ${PWD}

sudo docker exec -it wp-${DB_CONTAINER_NAME} sudo docker exec -it ${DB_CONTAINER_NAME} \
    mysqldump -u root --password=${DB_PASSWORD} wordpress > ${DUMPED_FILE}
