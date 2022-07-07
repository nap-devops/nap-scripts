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

echo "Dumping from [${DB_CONTAINER_NAME}]..."
sudo docker exec -it ${DB_CONTAINER_NAME} \
    mysqldump -u root --password=${DB_PASSWORD} wordpress > ${DUMPED_FILE}

#Tar wp-content from original container
echo "Packing wp-content from [${APP_PATH}]..."
cd ${APP_PATH}
#sudo tar -cvf ${TAR_NAME} wp-content
cd ${PWD}

#export USE_GKE_GCLOUD_AUTH_PLUGIN=True
WP_POD=$(kubectl get pods -n web-${PROFILE} --no-headers -o custom-columns=":metadata.name" | grep wordpress)
DB_POD=web-${PROFILE}-production-mariadb-0
NS=web-${PROFILE}

kubectl cp ${TAR_NAME} ${NS}/${WP_POD}:/bitnami/wordpress
kubectl cp ${DUMPED_FILE} ${NS}/${DB_POD}:/tmp
