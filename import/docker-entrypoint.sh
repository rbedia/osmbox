#!/bin/bash

shopt -s nullglob

osm_zips=( /var/osm/*.zip )
if [ -n $osm_zips ]
then
	osm_zip="${osm_zips[0]}"
	osm_pbf="${osm_zip%.*}.pbf"

	if [ "$osm_zip" -nt "$osm_pbf" ]
	then
		/usr/bin/unzip -p "${osm_zip}" | \
			/usr/bin/osmconvert - -o="${osm_pbf}"
	fi
fi

exec /opt/imposm3/imposm3 \
	import \
	-read "$osm_pbf" \
	-write \
	-optimize \
	-deployproduction \
	-connection "postgis://${POSTGRESQL_USER}:${POSTGRESQL_PASSWORD}@db/${POSTGRESQL_DATABASE}" \
	-mapping "/etc/imposm/mapping.yml"
