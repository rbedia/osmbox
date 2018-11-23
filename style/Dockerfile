FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    curl \
    python3 \
    python3-yaml \
 && rm -rf /var/lib/apt/lists/*

RUN curl -L -o /tmp/magnacarto.tar.gz https://download.omniscale.de/magnacarto/rel/dev-20180115-39b3cd9/magnacarto-dev-20180115-39b3cd9-linux-amd64.tar.gz && \
    tar -z -x -C /opt -f /tmp/magnacarto.tar.gz && \
    mv /opt/magnacarto-* /opt/magnacarto && \
    rm /tmp/magnacarto.tar.gz

COPY generate_config.py /opt/generate_config.py
COPY create-style /opt/create-style
RUN chmod +x /opt/create-style /opt/generate_config.py

ENTRYPOINT ["/bin/bash", "/opt/create-style"]

