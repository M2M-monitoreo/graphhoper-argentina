# syntax=docker/dockerfile:1
# ─────────────────────────────────────────────
# Stage 1: Build GraphHopper desde el código fuente
# ─────────────────────────────────────────────
FROM maven:3-eclipse-temurin-21 AS build

WORKDIR /usr/src/graphhopper

# Copiamos el código fuente clonado por build.sh
COPY graphhopper .

# Compilamos sin tests para acelerar el build
RUN mvn clean package -DskipTests -pl web --also-make

# ─────────────────────────────────────────────
# Stage 2: Imagen final liviana
# ─────────────────────────────────────────────
FROM eclipse-temurin:21-jre

LABEL maintainer="tu-usuario"
LABEL description="GraphHopper con datos OSM de Argentina"

WORKDIR /usr/src/app

# Copiamos el jar y archivos de configuración
COPY --from=build /usr/src/graphhopper/web/target/graphhopper*.jar ./
COPY --from=build /usr/src/graphhopper/config-example.yml ./
COPY config.yml ./
COPY graphhopper.sh ./

RUN chmod +x graphhopper.sh && mkdir -p /data

VOLUME ["/data"]

# Puerto de la API REST de GraphHopper
EXPOSE 8989

ENV JAVA_OPTS="-Xmx2g -Xms2g"

ENTRYPOINT ["/usr/src/app/graphhopper.sh"]

# Por defecto: levanta el servidor con el PBF de Argentina pre-descargado en /data
CMD ["--url", "https://download.geofabrik.de/south-america/argentina-latest.osm.pbf", "--host", "0.0.0.0", "--config", "/usr/src/app/config.yml"]