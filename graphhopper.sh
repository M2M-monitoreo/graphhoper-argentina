#!/bin/sh
set -eu

JAVA="${JAVA_HOME:-/opt/java/openjdk}/bin/java"
JAVA_OPTS="${JAVA_OPTS:--Xmx2g -Xms2g}"
JAR="$(find /usr/src/app -maxdepth 1 -name 'graphhopper*.jar' | head -n 1)"
GRAPH_DIR="/data/argentina-gh"

if [ ! -d "$GRAPH_DIR" ]; then
  echo "► Error: grafo pre-procesado no encontrado en $GRAPH_DIR"
  exit 1
fi

echo ""
echo "► Iniciando GraphHopper con datos embebidos..."

exec "$JAVA" $JAVA_OPTS \
  -jar "$JAR" \
  server /usr/src/app/config.yml