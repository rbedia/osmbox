#!/bin/bash

exec /opt/imposm3/imposm3 \
	"$@" \
	-connection "postgis://${POSTGRESQL_USER}:${POSTGRESQL_PASSWORD}@db/${POSTGRESQL_DATABASE}" \
	-mapping "/etc/imposm/mapping.yml"

