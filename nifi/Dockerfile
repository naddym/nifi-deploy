ARG NIFI_VERSION=1.15.3
FROM apache/nifi:${NIFI_VERSION}

ARG MAINTAINER="Mohammed Nadeem"
LABEL maintainer="${MAINTAINER}"

# Renew ARG
ARG NIFI_VERSION

ARG BASE_EXTENSION_URL=https://repo1.maven.org/maven2
ARG NIFI_EASYRULES_PATH=org/apache/nifi/nifi-easyrules-nar/${NIFI_VERSION}/nifi-easyrules-nar-${NIFI_VERSION}

USER root

# Extension scripts to support OIDC and cert management
ADD sh/ ${NIFI_BASE_DIR}/scripts/
RUN chmod -R +x /opt/nifi/scripts/*.sh

# Download and validate easyrules nar bundle
RUN curl -fSL ${BASE_EXTENSION_URL}/${NIFI_EASYRULES_PATH}.nar -o nifi-easyrules-nar-${NIFI_VERSION}.nar \
    && echo "$(curl ${BASE_EXTENSION_URL}/${NIFI_EASYRULES_PATH}.nar.sha1)" nifi-easyrules-nar-${NIFI_VERSION}.nar | sha1sum -c - \
    && mv nifi-easyrules-nar-${NIFI_VERSION}.nar ${NIFI_HOME}/lib/
    
USER nifi