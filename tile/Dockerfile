FROM ubuntu:18.04

ENV SUPERVISOR_VERSION=3.3.1-1.1 \
    MAPNIK_VERSION=3.0.19+ds-1 \
    PYTHON_MAPNIK_VERSION=1:0.0~20180130-804a7947d-1

RUN apt-get update && apt-get install --no-install-recommends -y \
    ca-certificates \
    git \
    libmapnik3.0=${MAPNIK_VERSION} \
    libmapnik-dev=${MAPNIK_VERSION} \
    mapnik-utils=${MAPNIK_VERSION} \
    python-mapnik=${PYTHON_MAPNIK_VERSION} \
    autoconf \
    automake \
    build-essential \
    libtool \
    apache2 \
    apache2-dev \
    libpq-dev \
    fonts-droid-fallback \
    ttf-unifont \
    supervisor=${SUPERVISOR_VERSION} \
 && rm -rf /var/lib/apt/lists/*

# Verify that Mapnik has been installed correctly
RUN python -c 'import mapnik'

# Install mod_tile and renderd
RUN git clone --depth 1 https://github.com/openstreetmap/mod_tile.git \
 && cd mod_tile \
 && ./autogen.sh \
 && ./configure \
 && make \
 && make install \
 && make install-mod_tile \
 && ldconfig \
 && cd - \
 && rm -r mod_tile

# Configure mod_tile
COPY mod_tile.load /etc/apache2/mods-available/
COPY mod_tile.conf /etc/apache2/mods-available/
RUN a2enmod mod_tile \
 && install --owner=www-data --group=www-data -d /var/lib/mod_tile

# Configure renderd
COPY renderd.conf /usr/local/etc/renderd.conf
RUN install --owner=www-data --group=www-data -d /var/run/renderd

COPY supervisord.conf /etc/supervisord.conf

COPY start-renderd /opt/
RUN chmod +x /opt/start-renderd

EXPOSE 80
CMD ["/usr/bin/supervisord", "--nodaemon", "--configuration=/etc/supervisord.conf"]

