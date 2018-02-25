# osmbox
Docker images for creating an OpenStreetMap tile server

## Usage

Create docker images.
```
./scripts/build-db
./scripts/build-imposm
./scripts/build-style
./scripts/build-tile
```

Import data.
```
./scripts/start-db
./scripts/imposm-all
```

Generate Mapnik style from CartoCSS.
```
./scripts/create-style
```

Start tile server.
```
./scripts/start-tile
```

