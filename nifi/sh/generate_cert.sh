#!/bin/sh -e

cert_dir="${NIFI_HOME}/conf/node_certs"
config_json_path="${cert_dir}/config.json"

mkdir -p "${cert_dir}"
# We have to change directory where we will be generating
# keystore/truststore files otherwise they would be stored
# in nifi home (aka /home/nifi) if we didn't change directory
cd "${cert_dir}"

if  [ -e "${config_json_path}" ]
then
  echo "'${config_json_path}' exists. Not requesting for new cert from ${CA_SERVER_HOST}"

  ${NIFI_TOOLKIT_HOME}/bin/tls-toolkit.sh client \
    --useConfigJson \
    --configJsonIn "${config_json_path}" \
    --configJson "${config_json_path}"
else
  subject_alt_names="${CA_SANS},$(hostname -f)"
  
  certificate_owner="CN=${WEB_HTTPS_HOST:-$(hostname -f)}, OU=NIFI"

  echo "'${config_json_path}' doesn't exists. Generating new cert from ${CA_SERVER_HOST} for ${certificate_owner}"

  ${NIFI_TOOLKIT_HOME}/bin/tls-toolkit.sh client \
    --certificateAuthorityHostname "${CA_SERVER_HOST}" \
    --certificateDirectory "${cert_dir}" \
    --configJson "${config_json_path}" \
    --dn  "${certificate_owner}" \
    --PORT "${CA_SERVER_PORT}" \
    --token "${CA_TOKEN}" \
    --subjectAlternativeNames "${subject_alt_names}"

  echo "Generated cert for node ${certificate_owner} from ${CA_SERVER_HOST}"
fi


if [ -f "${config_json_path}" ];  
then
  KEYSTORE_FILE=$(cat ./config.json | jq -r '.keyStore')
  KEYSTORE_TYPE=$(cat ./config.json | jq -r '.keyStoreType')
  KEYSTORE_PASSWORD=$(cat ./config.json | jq -r '.keyStorePassword')
  KEY_PASSWORD=$(cat ./config.json | jq -r '.keyPassword')
  TRUSTSTORE_FILE=$(cat ./config.json | jq -r '.trustStore')
  TRUSTSTORE_TYPE=$(cat ./config.json | jq -r '.trustStoreType')
  TRUSTSTORE_PASSWORD=$(cat ./config.json | jq -r '.trustStorePassword')

  # configure keystore/truststore
  prop_replace 'nifi.security.keystore' "${cert_dir}/${KEYSTORE_FILE}"
  prop_replace 'nifi.security.keystoreType' "${KEYSTORE_TYPE}"
  prop_replace 'nifi.security.keystorePasswd' "${KEYSTORE_PASSWORD}"
  prop_replace 'nifi.security.keyPasswd' "${KEY_PASSWORD}"
  prop_replace 'nifi.security.truststore' "${cert_dir}/${TRUSTSTORE_FILE}"
  prop_replace 'nifi.security.truststoreType' "${TRUSTSTORE_TYPE}"
  prop_replace 'nifi.security.truststorePasswd' "${TRUSTSTORE_PASSWORD}"

  cd ${NIFI_HOME}
else
  echo "Unable to read security settings from ${config_json_path}"
  exit 1
fi