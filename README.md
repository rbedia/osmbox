# osmbox
Docker images for creating an OpenStreetMap tile server.

## Components

* osmbox-db - PostgreSQL database server with PostGIS and hstore.
* osmbox-import - Imports OSM data into PostgreSQL using imposm.
* osmbox-style - Converts CartoCSS to Mapnik format.
* osmbox-tile - Runs a tile server using Apache, mod_tile, renderd, and Mapnik.

## Usage

Create docker images.
```
docker build -t osmbox-db:latest db
docker build -t osmbox-import:latest import
docker build -t osmbox-style:latest style
docker build -t osmbox-tile:latest tile
```

Create a volume to store the database.
```
docker volume create osmbox-db
```

Start the database. Change the username and password.
```
docker run -d --name osmbox_db \
	-e POSTGRES_USER=powerpy \
	-e POSTGRES_PASSWORD=randomword \
	-e POSTGRES_DB=powerpy \
	--mount source=osmbox-db,target=/var/lib/postgresql/data \
	osmbox-db:latest
```

Put imposm mapping.yml file in the styles directory.
Put the file to load in the source directory. The file can be a .pbf or a .zip
file containing an .osm file.

Import data.
```
docker run \
    --link osmbox_db:db \
	-e POSTGRESQL_USER=powerpy \
	-e POSTGRESQL_PASSWORD=randomword \
	-e POSTGRESQL_DATABASE=powerpy \
    -v $PWD/styles:/opt/osmbox \
    -v $PWD/source:/var/osm \
	osmbox-import:latest $@
```

Put layers and CartoCSS stylesheets in the styles directory.

Generate Mapnik style from CartoCSS.
```
docker run \
	-e POSTGRES_USER=powerpy \
	-e POSTGRES_PASSWORD=randomword \
	-e POSTGRES_DB=powerpy \
	-v $PWD/styles:/opt/osmbox \
	-v $PWD/styles-out:/var/osmbox \
	osmbox-style:latest
```

Start the tile server.
```
docker run -d \
    --name osmbox_tile \
    --link osmbox_db:db \
	-e POSTGRES_USER=powerpy \
	-e POSTGRES_PASSWORD=randomword \
	-e POSTGRES_DB=powerpy \
	-v $PWD/styles-out:/var/osmbox \
	-p 8112:80 \
	osmbox-tile:latest
```

## Credits

Based on the work of:

* https://github.com/OsmHackTW
* https://github.com/openinframap
* https://switch2osm.org

