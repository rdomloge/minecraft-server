FROM arm32v7/openjdk:11-jdk-slim

# Enable us to build ARM images in an i386 environment
COPY qemu-arm-static /usr/bin/qemu-arm-static

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y wget
RUN apt-get install -y git

RUN mkdir ~/minecraft
RUN cd ~/minecraft
RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar

RUN java -Xmx2048M -jar BuildTools.jar

VOLUME ["/data"]
#COPY server.properties /tmp/server.properties
#COPY log4j2.xml /tmp/log4j2.xml
WORKDIR /data

ENV JVM_XX_OPTS="-XX:+UseG1GC" MEMORY="1G" \
  TYPE=SPIGOT VERSION=LATEST FORGEVERSION=RECOMMENDED SPONGEBRANCH=STABLE SPONGEVERSION= FABRICVERSION=LATEST LEVEL=world \
  PVP=true DIFFICULTY=easy ENABLE_RCON=true RCON_PORT=25575 RCON_PASSWORD=minecraft \
  LEVEL_TYPE=DEFAULT SERVER_PORT=25565 ONLINE_MODE=TRUE SERVER_NAME="Ramsay's Spigot Server" \
  REPLACE_ENV_VARIABLES="FALSE" ENV_VARIABLE_PREFIX="CFG_" \
  ENABLE_AUTOPAUSE=false AUTOPAUSE_TIMEOUT_EST=3600 AUTOPAUSE_TIMEOUT_KN=120 AUTOPAUSE_TIMEOUT_INIT=600 AUTOPAUSE_PERIOD=10


ENTRYPOINT [ "java",  "-Xms256M", "-Xmx2048M", "-DEULA=true", "-jar", "../spigot-1.15.2.jar", "nogui"]

EXPOSE 25565 25575

