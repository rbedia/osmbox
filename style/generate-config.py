#!/usr/bin/python3
import json
import os
import subprocess
import yaml

srs = '+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 '\
      '+x_0=0.0 +y_0=0.0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs +over'
dbname = os.environ['POSTGRES_DB']
dbuser = os.environ['POSTGRES_USER']
dbpassword = os.environ['POSTGRES_PASSWORD']
extent = '-20037508.34 -20037508.34 20037508.34 20037508.34'
geometry_field = 'geometry'

tilestache_cache_src = os.environ.get('TILESTACHE_CACHE_SRC', '/opt/osmbox/tilestache_cache.json')
layers_src = os.environ.get('LAYERS_SRC', '/opt/osmbox/layers.yml')
renderd_conf_out = os.environ.get('RENDERD_CONF', '/var/osmbox/renderd.conf')
out_dir = os.environ.get('LAYER_OUT_DIR', '/var/osmbox')

cache_conf = {
    'name': 'Disk',
    'path': '/tmp/stache',
    'umask': '0000',
    'dirs': 'portable',
    'gzip': ['xml', 'json']
}

try:
    # Allow configuring local caching
    with open(tilestache_cache_src) as f:
        cache_conf = json.load(f)
except IOError:
    pass


tilestache_conf = {
    'cache': cache_conf,
    'layers': {}
}

tile_template = """
[{name}]
URI=/osm_tiles/{name}/
XML=/var/osmbox/{name}.xml
HOST=localhost
TILESIZE=256

"""

with open(layers_src, 'r') as f:
    config = yaml.load(f)

for out_layer in config:
    mml = {
        'name': 'OpenInfraMap %s' % out_layer['name'],
        'Layer': [],
        'Stylesheet': ['%s.mss' % out_layer['name']],
        'format': 'png',
        'interactivity': False,
        'maxzoom': 18,
        'minzoom': 0,
        'srs': srs
    }
    for layer in out_layer['layers']:
        layer_config = {
            'Datasource': {
                'host': 'db',
                'user': dbuser,
                'password': dbpassword,
                'dbname': dbname,
                'extent': extent,
                'id': layer['name'],
                'key_field': '',
                'project': 'openinframap',
                'geometry_field': geometry_field,
                'srs': srs,
                'srid': 3857,
                'table': '(%s) AS data' % layer['query'],
                'type': 'postgis'
            },
            'class': '',
            'geometry': layer['geometry'],
            'id': layer['name'],
            'name': layer['name'],
            'srs': srs,
            'srs-name': '900913',
            'status': 'on'
        }
        mml['Layer'].append(layer_config)

    mml_file = '%s/%s.mml' % (out_dir, out_layer['name'])

    with open(mml_file, 'w') as f:
        json.dump(mml, f, sort_keys=True, indent=2)

    xml_file = '%s/%s.xml' % (out_dir, out_layer['name'])
    mc_cmd = ['/opt/magnacarto/magnacarto', '-mml', mml_file, '-out', xml_file]
    magnacarto_out = subprocess.check_output(mc_cmd, encoding='UTF-8')
    print(magnacarto_out, end='', flush=True)

    tilestache_conf['layers'][out_layer['name']] = {
        'cache lifespan': '259200',
        'maximum cache age': '18000',
        'provider': {
            'name': 'mapnik',
            'mapfile': '%s.xml' % out_layer['name']
        },
        'metatile': {
            'rows': 4,
            'columns': 4,
            'buffer': 64
        }
    }

with open(renderd_conf_out, 'w') as f:
    for out_layer in config:
        f.write(tile_template.format(name=out_layer['name']))

with open(out_dir + '/tilestache.json', 'w') as f:
    json.dump(tilestache_conf, f, sort_keys=True, indent=2)

