ARG NIFI_REGISTRY_VERSION=1.15.3

FROM openjdk:8-jre AS toolkit_binary

ARG MAINTAINER="Mohammed Nadeem"
LABEL maintainer="${MAINTAINER}"

ARG NIFI_TOOLKIT_VERSION=1.15.3

ENV NIFI_TOOLKIT_BASE_DIR=/opt/nifi-toolkit
ENV NIFI_TOOLKIT_HOME=${NIFI_TOOLKIT_BASE_DIR}/nifi-toolkit-current

ARG BASE_URL=https://archive.apache.org/dist
ARG MIRROR_BASE_URL=${MIRROR_BASE_URL:-${BASE_URL}}

ARG DISTRO_PATH=${DISTRO_PATH:-${NIFI_TOOLKIT_VERSION}}
ARG NIFI_TOOLKIT_BINARY_PATH=${NIFI_TOOLKIT_BINARY_PATH:-/nifi/${DISTRO_PATH}/nifi-toolkit-${NIFI_TOOLKIT_VERSION}-bin.zip}

RUN apt-get update \
    && apt-get install -y unzip \
    && mkdir -p ${NIFI_TOOLKIT_BASE_DIR}

# Download, validate, and expand Apache NiFi Toolkit binary.
RUN curl -fSL ${MIRROR_BASE_URL}/${NIFI_TOOLKIT_BINARY_PATH} -o ${NIFI_TOOLKIT_BASE_DIR}/nifi-toolkit-${NIFI_TOOLKIT_VERSION}-bin.zip \
    && echo "$(curl ${BASE_URL}/${NIFI_TOOLKIT_BINARY_PATH}.sha256) *${NIFI_TOOLKIT_BASE_DIR}/nifi-toolkit-${NIFI_TOOLKIT_VERSION}-bin.zip" | sha256sum -c - \
    && unzip ${NIFI_TOOLKIT_BASE_DIR}/nifi-toolkit-${NIFI_TOOLKIT_VERSION}-bin.zip -d ${NIFI_TOOLKIT_BASE_DIR} \
    && rm ${NIFI_TOOLKIT_BASE_DIR}/nifi-toolkit-${NIFI_TOOLKIT_VERSION}-bin.zip \
    && mv ${NIFI_TOOLKIT_BASE_DIR}/nifi-toolkit-${NIFI_TOOLKIT_VERSION} ${NIFI_TOOLKIT_HOME}


FROM apache/nifi-registry:${NIFI_REGISTRY_VERSION}

ARG MAINTAINER="Mohammed Nadeem"
LABEL maintainer="${MAINTAINER}"

ARG NIFI_TOOLKIT_VERSION=${NIFI_TOOLKIT_VERSION:-${NIFI_REGISTRY_VERSION}}

ARG UID=1000
ARG GID=1000

ENV NIFI_TOOLKIT_BASE_DIR=/opt/nifi-toolkit
ENV NIFI_TOOLKIT_HOME=${NIFI_TOOLKIT_BASE_DIR}/nifi-toolkit-current

USER root

# Extension scripts to support OIDC and cert management
ADD sh/ ${NIFI_REGISTRY_BASE_DIR}/scripts/
RUN chmod -R +x /opt/nifi-registry/scripts/*.sh

COPY --chown=${UID}:${GID} --from=toolkit_binary ${NIFI_TOOLKIT_HOME} ${NIFI_TOOLKIT_BASE_DIR}

USER nifi