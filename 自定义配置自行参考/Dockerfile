FROM ubuntu:latest

RUN sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list \
    && sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list

USER root

RUN set -x \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    lib32stdc++6 \
    lib32gcc1 \
    libcurl4-gnutls-dev:i386 \
    wget \
    ca-certificates \
    && mkdir -p /root/DST \
    && mkdir -p /root/steamcmd \
    && mkdir -p /root/.klei/DoNotStarveTogether/ \
    && mkdir -p /root/DST/mods \
    && cd /root/steamcmd \
    && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar -xvzf steamcmd_linux.tar.gz \
    && cd /root/steamcmd \
    && ./steamcmd.sh +login anonymous +force_install_dir /root/DST +app_update 343050 +quit \    
    && apt-get remove --purge -y wget \
    ca-certificates \
    unzip \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN cd /root/DST/bin  \
    && echo "/root/steamcmd/steamcmd.sh +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 +login anonymous +force_install_dir /root/DST +app_update 343050 +quit" > start.sh  \ 
    && echo "/root/DST/bin/dontstarve_dedicated_server_nullrenderer -only_update_server_mods" >> start.sh \  
    && echo "/root/DST/bin/dontstarve_dedicated_server_nullrenderer -shard Master & /root/DST/bin/dontstarve_dedicated_server_nullrenderer -shard Caves" >> start.sh  \
    && chmod +x start.sh

VOLUME /root/.klei/DoNotStarveTogether/Cluster_1
VOLUME /root/DST/mods

EXPOSE 10999/udp
EXPOSE 10998/udp

WORKDIR /root/DST/bin
CMD "/root/DST/bin/start.sh"