FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    osmctools \
 && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/osmconvert"]

