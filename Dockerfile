FROM ubuntu:latest

RUN sed -i "s@http://.*archive.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list \
    && sed -i "s@http://.*security.ubuntu.com@http://repo.huaweicloud.com@g" /etc/apt/sources.list

RUN set -x \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    lib32stdc++6 \
    lib32gcc1 \
    libcurl4-gnutls-dev:i386 \
    wget \
    ca-certificates \
    unzip \
    && mkdir -p /root/DST \
    && mkdir -p /root/steamcmd \
    && cd /root/steamcmd \
    && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar -xvzf steamcmd_linux.tar.gz \
    && cd /root/steamcmd \
    && ./root/steamcmd/steamcmd.sh +login anonymous +force_install_dir /root/DST +app_update 343050 +quit \    
    && mkdir -p /root/.klei/DoNotStarveTogether/ \
    && cd /root/.klei/DoNotStarveTogether/ \
    && wget https://github.com/yanxin152133/DST/blob/master/MyDediServer.rar \
    && tar -xvzf MyDediServer.rar \
    && mkdir -p /root/DST/mods \
    && cd /root/DST/mods \
    && wget https://github.com/yanxin152133/DST/blob/master/mod.rar \
    && tar -xvzf mod.rar \
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

EXPOSE 11000/udp
EXPOSE 10999/udp

WORKDIR /root/DST/bin
CMD "/root/DST/bin/start.sh"