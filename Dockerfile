FROM almalinux
RUN rpm -i https://github.com/sigstore/cosign/releases/download/v2.0.2/cosign-2.0.2.x86_64.rpm
ADD ./entrypoint.sh /bin/entrypoint.sh
RUN chmod 777 /bin/entrypoint.sh
RUN useradd cosign -m -s /bin/bash
ENTRYPOINT ["/bin/entrypoint.sh"]
USER cosign

