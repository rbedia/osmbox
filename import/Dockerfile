FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    curl \
    osmctools \
    unzip \
 && rm -rf /var/lib/apt/lists/*

RUN curl -L -o /tmp/imposm3.tar.gz https://imposm.org/static/rel/imposm3-0.4.0dev-20170519-3f00374-linux-x86-64.tar.gz && \
    mkdir -p /opt && \
    tar -z -x -C /opt -f /tmp/imposm3.tar.gz && \
    mv /opt/imposm3-* /opt/imposm3 && \
    rm /tmp/imposm3.tar.gz

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

