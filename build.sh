#!/usr/bin/env bash
set -euo pipefail

DOCKERHUB_IMAGE="tu-usuario/graphhopper-argentina"

# ── Clonar / actualizar GraphHopper ──
if [[ ! -d graphhopper ]]; then
  echo "► Clonando graphhopper..."
  git clone https://github.com/graphhopper/graphhopper.git
else
  echo "► Actualizando graphhopper..."
  (cd graphhopper; git checkout master; git pull)
fi

# ── Tag de imagen ──
VERSION_TAG="${1:-latest}"
IMAGE_NAME="${DOCKERHUB_IMAGE}:${VERSION_TAG}"

echo ""
echo "════════════════════════════════"
echo "  Imagen : $IMAGE_NAME"
echo "════════════════════════════════"
echo ""

# ── Build local ──
docker build -t "$IMAGE_NAME" .

echo ""
echo "✓ Build completado: $IMAGE_NAME"
echo ""
echo "Para probar:"
echo "  mkdir -p data"
echo "  docker run -p 8989:8989 -v \$(pwd)/data:/data $IMAGE_NAME"
