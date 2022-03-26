#!/bin/sh -e

#    Licensed to the Apache Software Foundation (ASF) under one or more
#    contributor license agreements.  See the NOTICE file distributed with
#    this work for additional information regarding copyright ownership.
#    The ASF licenses this file to You under the Apache License, Version 2.0
#    (the "License"); you may not use this file except in compliance with
#    the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
scripts_dir='/opt/nifi-registry/scripts'

[ -f "${scripts_dir}/update_authorizers.sh" ] && . "${scripts_dir}/update_authorizers.sh"

echo 'Configuring OIDC settings'

prop_replace "nifi.registry.security.user.oidc.discovery.url" "${NIFI_REGISTRY_SECURITY_USER_OIDC_DISCOVERY_URL}"
prop_replace "nifi.registry.security.user.oidc.connect.timeout" "${NIFI_REGISTRY_SECURITY_USER_OIDC_CONNECT_TIMEOUT:-5 secs}"
prop_replace "nifi.registry.security.user.oidc.read.timeout" "${NIFI_REGISTRY_SECURITY_USER_OIDC_READ_TIMEOUT:-5 secs}"
prop_replace "nifi.registry.security.user.oidc.client.id" "${NIFI_REGISTRY_SECURITY_USER_OIDC_CLIENT_ID:-$(cat ${NIFI_REGISTRY_SECURITY_USER_OIDC_CLIENT_ID_FILE})}"
prop_replace "nifi.registry.security.user.oidc.client.secret" "${NIFI_REGISTRY_SECURITY_USER_OIDC_CLIENT_SECRET:-$(cat ${NIFI_REGISTRY_SECURITY_USER_OIDC_CLIENT_SECRET_FILE})}"
prop_replace "nifi.registry.security.user.oidc.preferred.jwsalgorithm" "${NIFI_REGISTRY_SECURITY_USER_OIDC_PREFERRED_JWSALGORITHM}"

prop_replace "nifi.registry.security.needClientAuth" "false"