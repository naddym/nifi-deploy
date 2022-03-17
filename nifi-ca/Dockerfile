ARG NIFI_TOOLKIT_VERSION=1.15.3
FROM apache/nifi-toolkit:${NIFI_TOOLKIT_VERSION}

ARG MAINTAINER="Mohammed Nadeem"
LABEL maintainer="${MAINTAINER}"

USER root

# Override base image ENTRYPOINT
COPY --chown=nifi:nifi docker-entrypoint.sh /opt/sh/
RUN chmod -R +x /opt/sh/docker-entrypoint.sh

# Create directory to bind mount
RUN mkdir -p ${NIFI_TOOLKIT_BASE_DIR}/certs \
    && chown -R nifi:nifi ${NIFI_TOOLKIT_BASE_DIR}/certs

USER nifi

VOLUME ${NIFI_TOOLKIT_BASE_DIR}/certs