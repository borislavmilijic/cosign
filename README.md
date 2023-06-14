This is the container for checking and signing images in OCI-registry.
You don't need to mount anything and you can use any user for this container

*Prapare eviroment variables:*
```bash
## use secret files from jenkins for ./cosign.pub and ./cosign.key
COSIGN_PUB=$(base64 -w0 ./cosign.pub)
COSIGN_KEY=$(base64 -w0 ./cosign.key)
## use secrets from jenkins
COSIGN_PASS='<>'
OCI_REGISTRY="<>"
OCI_PASS='<>'
OCI_LOGIN='<>'
```

This is the example how to use it:
For verification:
```bash
podman run --rm -ti \
 -e COSIGN_PASS=${COSIGN_PASS}\
 -e COSIGN_KEY=${COSIGN_KEY}\
 -e COSIGN_PUB=${COSIGN_PUB}\
 -e OCI_REGISTRY=${OCI_REGISTRY}\
 -e OCI_PASS=${OCI_PASS}\
 -e OCI_LOGIN=${OCI_LOGIN}\
 auroranexus.smartstream-stp.com:5000/cosign verify auroranexus.smartstream-stp.com:5000/aurora-messaging-service/camt-camel:8.6.5-R5
```
For signing:
```bash
podman run --rm -ti \
 -e COSIGN_PASS=${COSIGN_PASS}\
 -e COSIGN_KEY=${COSIGN_KEY}\
 -e COSIGN_PUB=${COSIGN_PUB}\
 -e OCI_REGISTRY=${OCI_REGISTRY}\
 -e OCI_PASS=${OCI_PASS}\
 -e OCI_LOGIN=${OCI_LOGIN}\
 auroranexus.smartstream-stp.com:5000/cosign sign auroranexus.smartstream-stp.com:5000/aurora-messaging-service/camt-camel:8.6.5-R5
```
You also can use custom commans:
```bash
podman run --rm -ti \
 -e COSIGN_PASS=${COSIGN_PASS}\
 -e COSIGN_KEY=${COSIGN_KEY}\
 -e COSIGN_PUB=${COSIGN_PUB}\
 -e OCI_REGISTRY=${OCI_REGISTRY}\
 -e OCI_PASS=${OCI_PASS}\
 -e OCI_LOGIN=${OCI_LOGIN}\
 auroranexus.smartstream-stp.com:5000/cosign cosign sing --key ~/cosign.pub auroranexus.smartstream-stp.com:5000/aurora-messaging-service/camt-camel:8.6.5-R5
```