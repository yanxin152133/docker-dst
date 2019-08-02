#!/bin/bash
steamcmd_dir="$HOME/steamcmd"
## 检查并更新更新游戏版本
cd "$steamcmd_dir"
./steamcmd.sh +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 +login anonymous +force_install_dir ../dontstarvetogether_dedicated_server +app_update 343050 validate +quit

