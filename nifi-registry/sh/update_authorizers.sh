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

# write the initial admin
xmlstarlet ed --inplace -u "authorizers/userGroupProvider/property[@name='Initial User Identity 1']" -v "${INITIAL_ADMIN_IDENTITY}" ${NIFI_REGISTRY_HOME}/conf/authorizers.xml
xmlstarlet ed --inplace -u "authorizers/accessPolicyProvider/property[@name='Initial Admin Identity']" -v "${INITIAL_ADMIN_IDENTITY}" ${NIFI_REGISTRY_HOME}/conf/authorizers.xml