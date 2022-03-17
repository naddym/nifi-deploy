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

scripts_dir='/opt/nifi/scripts'

[ -f "${scripts_dir}/update_authorizers.sh" ] && . "${scripts_dir}/update_authorizers.sh"

echo 'Configuring OIDC settings'

prop_replace "nifi.security.user.oidc.discovery.url" "${SECURITY_USER_OIDC_DISCOVERY_URL}"
prop_replace "nifi.security.user.oidc.connect.timeout" "${SECURITY_USER_OIDC_CONNECT_TIMEOUT:-5 secs}"
prop_replace "nifi.security.user.oidc.read.timeout" "${SECURITY_USER_OIDC_READ_TIMEOUT:-5 secs}"
prop_replace "nifi.security.user.oidc.client.id" "${SECURITY_USER_OIDC_CLIENT_ID:-$(cat ${SECURITY_USER_OIDC_CLIENT_ID_FILE})}"
prop_replace "nifi.security.user.oidc.client.secret" "${SECURITY_USER_OIDC_CLIENT_SECRET:-$(cat ${SECURITY_USER_OIDC_CLIENT_SECRET_FILE})}"
prop_replace "nifi.security.user.oidc.preferred.jwsalgorithm" "${SECURITY_USER_OIDC_PREFERRED_JWSALGORITHM}"
prop_replace "nifi.security.user.oidc.additional.scopes" "${SECURITY_USER_OIDC_ADDITIONAL_SCOPES:-}"
prop_replace "nifi.security.user.oidc.claim.identifying.user" "${SECURITY_USER_OIDC_CLAIM_IDENTIFYING_USER:-}"
prop_replace "nifi.security.user.oidc.fallback.claims.identifying.user" "${SECURITY_USER_OIDC_FALLBACK_CLAIMS_IDENTIFYING_USER:-}"