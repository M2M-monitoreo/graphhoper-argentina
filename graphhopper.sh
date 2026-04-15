#!/usr/bin/env bash
set -euo pipefail

JAVA="${JAVA_HOME:-/opt/java/openjdk}/bin/java"
JAVA_OPTS="${JAVA_OPTS:--Xmx2g -Xms2g}"
JAR=$(find /usr/src/app -maxdepth 1 -name "graphhopper*.jar" | head -1)
DATA_DIR="/data"
OSM_FILE="${DATA_DIR}/argentina-latest.osm.pbf"
OSM_URL="https://download.geofabrik.de/south-america/argentina-latest.osm.pbf"

# Descargar OSM si no existe
if [[ ! -f "$OSM_FILE" ]]; then
  echo "► Descargando OSM de Argentina..."
  wget -q --show-progress -O "$OSM_FILE" "$OSM_URL"
else
  echo "► Usando OSM ya descargado: $OSM_FILE"
fi

echo ""
echo "► Iniciando GraphHopper..."

exec "$JAVA" $JAVA_OPTS \
  -jar "$JAR" \
  server /usr/src/app/config.yml