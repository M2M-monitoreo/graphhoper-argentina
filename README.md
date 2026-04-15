# GraphHopper Argentina - Imagen Docker optimizada

## Inicio rápido

1. **Clonar GraphHopper** (si aún no lo hiciste):
   ```bash
   ./build.sh
   ```

2. **Construir y levantar la imagen** (una sola vez):
   ```bash
   docker compose up --build
   ```

3. **Próximas veces** (sin rebuild):
   ```bash
   docker compose up
   ```

4. **Acceder a la API**:
   - Web UI: http://localhost:8989
   - API REST: http://localhost:8989/route

## Detalles

- **Imagen**: ~770 MB (optimizada: sin PBF innecesario)
- **Base**: OpenJDK 21 Alpine
- **Perfil**: pre-incluye grafo procesado de Argentina
- **Datos**: `argentina-gh/` (grafo pre-procesado en /data)

## Push a Docker Hub

```bash
docker login
docker tag tu-usuario/graphhopper-argentina:latest tu_usuario_hub/graphhopper-argentina:latest
docker push tu_usuario_hub/graphhopper-argentina:latest
```