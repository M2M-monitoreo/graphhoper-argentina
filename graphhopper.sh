#!/bin/sh
set -eu

JAVA="${JAVA_HOME:-/opt/java/openjdk}/bin/java"
JAVA_OPTS="${JAVA_OPTS:--Xmx2g -Xms2g}"
JAR="$(find /usr/src/app -maxdepth 1 -name 'graphhopper*.jar' | head -n 1)"
OSM_FILE="/data/argentina-latest.osm.pbf"
GRAPH_DIR="/data/argentina-gh"

if [ ! -f "$OSM_FILE" ] || [ ! -d "$GRAPH_DIR" ]; then
  echo "► Falta el dataset de Argentina dentro de la imagen."
  echo "► Se espera encontrar: $OSM_FILE y $GRAPH_DIR"
  exit 1
fi

echo ""
echo "► Iniciando GraphHopper con datos embebidos..."

exec "$JAVA" $JAVA_OPTS \
  -jar "$JAR" \
  server /usr/src/app/config.yml