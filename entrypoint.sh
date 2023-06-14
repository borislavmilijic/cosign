#!/bin/bash
cd
mkdir -p ~/.docker || true
echo ${COSIGN_KEY} | base64 -d > ~/cosign.key
echo ${COSIGN_PUB} | base64 -d > ~/cosign.pub
OCI_AUTH=$(echo -n ${OCI_LOGIN}:${OCI_PASS} | base64 -w0)
OCI_CONF={\"auths\":{\"${OCI_REGISTRY}\":{\"auth\":\"${OCI_AUTH}\"}}}
echo ${OCI_CONF} > ~/.docker/config.json
echo $1
if [[ "$1" == "sign" ]]
then
        echo -n ${COSIGN_PASS} | cosign -y --allow-http-registry --allow-insecure-registry --key=$(echo ~/cosign.key) $@
elif [[ "$1" == "verify" ]]
then
        cosign --allow-http-registry --allow-insecure-registry --key=$(echo ~/cosign.pub) $@
else
$@
fi