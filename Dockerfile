# ReferĂȘncias https://docs.docker.com/engine/reference/builder/

FROM ubuntu:latest

LABEL maintainer="mateusallen05@gmail.com"

ARG GETH_URL=https://gethstore.blob.core.windows.net/builds/geth-alltools-linux-amd64-1.7.2-1db4ecdc.tar.gz
ARG GETH_MD5=c17c164d2d59d3972a2e6ecf922d2093
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install wget -y && \
    cd /tmp && \
    wget "$GETH_URL" -q -O /tmp/geth-alltools-linux-amd64.tar.gz && \
    echo "$GETH_MD5  geth-alltools-linux-amd64.tar.gz" > /tmp/geth-alltools-linux-amd64.tar.gz.md5 && \
    md5sum -c /tmp/geth-alltools-linux-amd64.tar.gz.md5 && \
    tar -xzf /tmp/geth-alltools-linux-amd64.tar.gz -C /usr/local/bin/ --strip-components=1 && \
    rm -f /usr/local/bin/COPYING && \
    rm -f /tmp/geth-alltools-*

ENV GEN_NONCE="0xeddeadbabeeddead" \
    DATA_DIR="/root/.ethereum" \
    CHAIN_TYPE="private" \
    RUN_BOOTNODE=false \
    GEN_CHAIN_ID=1981 \
    BOOTNODE_URL=""

WORKDIR /opt

# like ethereum/client-go
EXPOSE 30303
EXPOSE 8545

# bootnode port
EXPOSE 30301
EXPOSE 30301/udp

ADD src/* /opt/
RUN chmod +x /opt/*.sh

#CMD ["/opt/startgeth.sh"]
ENTRYPOINT ["/opt/startgeth.sh"]