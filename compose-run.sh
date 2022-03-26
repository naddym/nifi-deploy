#!/bin/sh -e

UID=1000
GUID=1000
VOLUME_DATA_PATH=/data

# create nifi-1 host mounts
mkdir -p ${VOLUME_DATA_PATH}/nifi-1/conf
mkdir -p ${VOLUME_DATA_PATH}/nifi-1/flowfile_repository
mkdir -p ${VOLUME_DATA_PATH}/nifi-1/content_repository
mkdir -p ${VOLUME_DATA_PATH}/nifi-1/database_repository
mkdir -p ${VOLUME_DATA_PATH}/nifi-1/provenance_repository
mkdir -p ${VOLUME_DATA_PATH}/nifi-1/state

# create nifi-2 host mounts
mkdir -p ${VOLUME_DATA_PATH}/nifi-2/conf
mkdir -p ${VOLUME_DATA_PATH}/nifi-2/flowfile_repository
mkdir -p ${VOLUME_DATA_PATH}/nifi-2/content_repository
mkdir -p ${VOLUME_DATA_PATH}/nifi-2/database_repository
mkdir -p ${VOLUME_DATA_PATH}/nifi-2/provenance_repository
mkdir -p ${VOLUME_DATA_PATH}/nifi-2/state

# create nifi-3 host mounts
mkdir -p ${VOLUME_DATA_PATH}/nifi-3/conf
mkdir -p ${VOLUME_DATA_PATH}/nifi-3/flowfile_repository
mkdir -p ${VOLUME_DATA_PATH}/nifi-3/content_repository
mkdir -p ${VOLUME_DATA_PATH}/nifi-3/database_repository
mkdir -p ${VOLUME_DATA_PATH}/nifi-3/provenance_repository
mkdir -p ${VOLUME_DATA_PATH}/nifi-3/state

# create nifi-ca host mounts
mkdir -p ${VOLUME_DATA_PATH}/nifi-ca

# create nifi-registry host mounts
mkdir -p ${VOLUME_DATA_PATH}/nifi-registry/certs
mkdir -p ${VOLUME_DATA_PATH}/nifi-registry/database
mkdir -p ${VOLUME_DATA_PATH}/nifi-registry/flow_storage
mkdir -p ${VOLUME_DATA_PATH}/nifi-registry/extension_bundles

# assign non-root permissions to nifi-1
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-1/conf
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-1/flowfile_repository
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-1/content_repository
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-1/database_repository
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-1/provenance_repository
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-1/state

# assign non-root permissions to nifi-2
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-2/conf
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-2/flowfile_repository
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-2/content_repository
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-2/database_repository
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-2/provenance_repository
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-2/state

# assign non-root permissions to nifi-3
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-3/conf
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-3/flowfile_repository
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-3/content_repository
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-3/database_repository
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-3/provenance_repository
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-3/state

# assign non-root permissions to nifi-ca
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-ca

# assign non-root permissions to nifi-registry
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-registry/certs
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-registry/database
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-registry/flow_storage
chown ${UID}:${GUID} -R ${VOLUME_DATA_PATH}/nifi-registry/extension_bundles

# generate self-signed certificate and private key for SSL/TLS communication 
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /home/ubuntu/nginx/nginx.key -out /home/ubuntu/nginx/nginx.crt -subj "/C=US/ST=Michigan/L=Detroit/O=FinAIApps,Inc/OU=FinTech/CN=nifi.finaiapps.com"


# Bring up compoase services
# docker-compose up

# Bring down compose services
# docker-compose down --volumes

# Bring down compose services by removing all images/volumes used
# docker-compose down --rmi all --volumes