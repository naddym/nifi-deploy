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
node_identities=${NODE_IDENTITIES}

# write the initial admin
xmlstarlet ed --inplace -u "authorizers/userGroupProvider/property[@name='Initial User Identity 1']" -v "${INITIAL_ADMIN_IDENTITY}" ${NIFI_HOME}/conf/authorizers.xml
xmlstarlet ed --inplace -u "authorizers/accessPolicyProvider/property[@name='Initial Admin Identity']" -v "${INITIAL_ADMIN_IDENTITY}" ${NIFI_HOME}/conf/authorizers.xml

# remove any whitespace from the node_identities list
node_identities=$(echo $node_identities | tr -d ' ')

authorizers_file="${NIFI_HOME}/conf/authorizers.xml"

evaluate_xmlstarlet() {
    action=${1}
    xpath=${2}
    attr_value=${3}
    elem_value=${4}
    id=${5}

    case ${action} in
    select)
        value=$(xmlstarlet select -t -v "${xpath}/property[@name='${attr_value} ${id}']" -n "${authorizers_file}")
        echo "${value}"
        ;;
    insert)
        xmlstarlet edit --inplace --delete "${xpath}/property[@name='${attr_value} ${id}']" "${authorizers_file}"
        xmlstarlet edit --inplace --subnode "${xpath}" -t elem -n property -v "future_value" "${authorizers_file}"
        xmlstarlet edit --inplace --insert "${xpath}/property[text() = 'future_value']" -t attr -n "name" -v "future_attr_value" "${authorizers_file}"
        xmlstarlet edit --inplace --update  "${xpath}/property[@name='future_attr_value']" --value "${elem_value}" "${authorizers_file}"
        xmlstarlet edit --inplace --update  "${xpath}/property[@name='future_attr_value']/@name" --value "${attr_value} ${id}" "${authorizers_file}"
        ;;
    update)
        xmlstarlet edit --inplace --update "${xpath}/property[@name='${attr_value} ${id}']" --value "${elem_value}" "${authorizers_file}"
        ;;
    esac
}

configure_authorizers() {
    xpath=${1}
    attr_value=${2}
    elem_value=${3}
    id=${4}

    value=$(evaluate_xmlstarlet select "${xpath}" "${attr_value}" "${elem_value}" "${id}")
    if [ -z "${value}" ] ;
    then
        evaluate_xmlstarlet insert "${xpath}" "${attr_value}" "${elem_value}" ${id}
    else
        evaluate_xmlstarlet update "${xpath}" "${attr_value}" "${elem_value}" ${id}
    fi
}

# write node_identities
user_id=2
for identity in $(echo $node_identities | sed "s/,/ /g")
do
  configure_authorizers "authorizers/userGroupProvider" "Initial User Identity" "CN=${identity}, OU=NIFI" "${user_id}"

  configure_authorizers "authorizers/accessPolicyProvider" "Node Identity" "CN=${identity}, OU=NIFI" "$((user_id-1))"

  user_id=$((user_id+1))
done