#!/bin/sh -e

UID=1000
GID=1000
VOLUME_DATA_PATH=/data

# provide nifi oidc client credentials
NIFI_OIDC_CLIENT_ID=
NIFI_OIDC_CLIENT_SECRET=

# provide nifi-registry oidc client credentials
NIFI_REGISTRY_OIDC_CLIENT_ID=
NIFI_REGISTRY_OIDC_CLIENT_SECRET=

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
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-1/conf
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-1/flowfile_repository
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-1/content_repository
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-1/database_repository
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-1/provenance_repository
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-1/state

# assign non-root permissions to nifi-2
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-2/conf
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-2/flowfile_repository
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-2/content_repository
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-2/database_repository
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-2/provenance_repository
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-2/state

# assign non-root permissions to nifi-3
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-3/conf
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-3/flowfile_repository
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-3/content_repository
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-3/database_repository
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-3/provenance_repository
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-3/state

# assign non-root permissions to nifi-ca
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-ca

# assign non-root permissions to nifi-registry
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-registry/certs
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-registry/database
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-registry/flow_storage
chown ${UID}:${GID} -R ${VOLUME_DATA_PATH}/nifi-registry/extension_bundles

# generate self-signed certificate and private key for SSL/TLS communication 
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx.key -out nginx.crt -subj "/C=US/ST=Michigan/L=Detroit/O=FinAIApps,Inc/OU=FinTech/CN=nifi.finaiapps.com"

# initialize docker swarm
docker swarm init

# create secrets of nginx certificate and private key
docker secret create nginx.crt nginx.crt
docker secret create nginx.key nginx.key

# create nifi oidc docker external secrets. Replace variables with actual values
echo ${NIFI_OIDC_CLIENT_ID} | docker secret create nifi_oidc_client_id -
echo ${NIFI_OIDC_CLIENT_SECRET} | docker secret create nifi_oidc_client_secret -

# create nifi-registry oidc docker external secrets. Replace variables with actual values
echo ${NIFI_REGISTRY_OIDC_CLIENT_ID} | docker secret create nifi_registry_oidc_client_id -
echo ${NIFI_REGISTRY_OIDC_CLIENT_SECRET} | docker secret create nifi_registry_oidc_client_secret -

# Bring up stack 
docker stack deploy -c docker-swarm.yml nifi-stack

# Remove stack
# docker stack rm nifi-stack

# Delete all volumes
# docker volume rm $(docker volume ls -q)

# List all services
# docker service ls