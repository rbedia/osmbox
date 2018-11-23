FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    curl \
    osmctools \
    unzip \
 && rm -rf /var/lib/apt/lists/*

RUN curl -L -o /tmp/imposm.tar.gz https://github.com/omniscale/imposm3/releases/download/v0.6.0-alpha.4/imposm-0.6.0-alpha.4-linux-x86-64.tar.gz && \
    mkdir -p /opt && \
    tar -z -x -C /opt -f /tmp/imposm.tar.gz && \
    mv /opt/imposm-* /opt/imposm && \
    rm /tmp/imposm.tar.gz

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

