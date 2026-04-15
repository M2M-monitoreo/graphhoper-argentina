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
# Stage 2: Imagen final autosuficiente
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
COPY data /data

RUN apt-get update \
	&& apt-get install -y --no-install-recommends wget \
	&& rm -rf /var/lib/apt/lists/* \
	&& chmod +x graphhopper.sh

# Puerto de la API REST de GraphHopper
EXPOSE 8989

ENV JAVA_OPTS="-Xmx2g -Xms2g"

ENTRYPOINT ["/usr/src/app/graphhopper.sh"]