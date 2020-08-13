# 1. 饥荒专用服务器
## 1.1. 安装Docker
安装步骤参考以下链接：     
- [docker安装](https://yanxin152133.github.io/notes/#/notes/Docker/%E6%95%99%E7%A8%8B/Docker%E5%AE%89%E8%A3%85)
## 1.2. 服务器配置文件
```html
├── Cluster_1    ## 配置地上世界和洞穴以及一些必要的配置
│   ├── Caves     ## 洞穴配置
│   │   ├── modoverrides.lua  ## mod参数配置
│   │   ├── server.ini   ## 洞穴独立配置文件
│   │   ├── server_chat_log.txt  ## 聊天日志
│   │   ├── server_log.txt  ## 系统日志
│   │   └── worldgenoverride.lua  ##世界地图配置
│   ├── Master  ## 地上世界配置
│   │   ├── modoverrides.lua  ## mod参数配置
│   │   ├── server.ini   ## 洞穴独立配置文件
│   │   ├── server_chat_log.txt  ## 聊天日志
│   │   ├── server_log.txt  ## 系统日志
│   │   └── worldgenoverride.lua  ##世界地图配置
│   ├── admin.txt  ## 管理员名单
│   ├── blocklist.txt   ## 黑名单
│   ├── cluster.ini   ## 通用配置文件
│   ├── cluster_token.txt  ## token
│   └── whitelist.txt  ## 白名单
├── mods   ## mod配置
│   └── dedicated_server_mods_setup.lua   ## 保存服务器所用到的mod
```
      
### 1.2.1. cluster.ini
```html
[MISC]
max_snapshots = 6                  # 最大快照数，决定了可回滚的天数
console_enabled = true             # 是否开启控制台
 
[SHARD]
shard_enabled = true               # 服务器共享，要开启洞穴服务器的必须启用
bind_ip = 127.0.0.1                # 服务器监听的地址，当所有实例都运行在同一台机器时，可填写 127.0.0.1，会被 server .ini 覆盖
master_ip = 127.0.0.1              # master 服务器的 IP，针对非 master 服务器，若与 master 服务器运行在同一台机器时，可填写 127.0.0.1，会被 server.ini 覆盖
master_port = 10888                # 监听 master 服务器的 UDP 端口，所有连接至 master 服务器的非 master 服务器必须相同
cluster_key = dst                  # 连接密码，每台服务器必须相同，会被 server.ini 覆盖
 
[STEAM]
steam_group_only = false           # 只允许某 Steam 组的成员加入
steam_group_id = 0                 # 指定某个 Steam 组，填写组 ID
steam_group_admins = false         # 开启后，Steam 组的管理员拥有服务器的管理权限
 
[NETWORK]
offline_server = false             # 离线服务器，只有局域网用户能加入，并且所有依赖于 Steam 的任何功能都无效，比如说饰品掉落
tick_rate = 15                     # 每秒通信次数，越高游戏体验越好，但是会加大服务器负担
whitelist_slots = 0                # 为白名单用户保留的游戏位
cluster_password =                 # 游戏密码，不设置表示无密码
cluster_name = ttionya test        # 游戏房间名称
cluster_description = description  # 游戏房间描述
lan_only_cluster = false           # 局域网游戏
cluster_intention = madness        # 游戏偏好，可选 cooperative, competitive, social, or madness，随便设置，没卵用
autosaver_enabled = true           # 自动保存
 
[GAMEPLAY]
max_players = 16                   # 最大游戏人数
pvp = true                         # 能不能攻击其他玩家，能不能给其他玩家喂屎
game_mode = survival               # 游戏模式，可选 survival, endless or wilderness，与玩家死亡后的负面影响有关
pause_when_empty = false           # 没人服务器暂停，刷天数必备
vote_kick_enabled = false          # 投票踢人
```
      
### 1.2.2. server.ini
```html
[SHARD]
is_master = true /false      # 是否是 master 服务器，只能存在一个 true，其他全是 false
name = caves                 # 针对非 master 服务器的名称
id = ???                     # 随机生成，不用加入该属性
 
[STEAM]
authentication_port = 8766   # Steam 用的端口，确保每个实例都不相同
master_server_port = 27016   # Steam 用的端口，确保每个实例都不相同
 
[NETWORK]
server_port = 10999          # 监听的 UDP 端口，只能介于 10998 - 11018 之间，确保每个实例都不相同
```
       
### 1.2.3. dedicated_server_mods_setup.lua
```html
## 以下是模版，根据需要替换“”之内的内容
ServerModSetup("workshop-1301033176")
ServerModSetup("workshop-378160973")
ServerModSetup("workshop-458587300")
ServerModSetup("workshop-666155465")
ServerModSetup("workshop-934638020")
```
      
### 1.2.4. modoverrides.lua
```html
## 本地创建饥荒服务器生成后，复制粘贴即可
return {
  ["workshop-1301033176"]={ configuration_options={ LANG="auto" }, enabled=true },
  ["workshop-378160973"]={
    configuration_options={
      ENABLEPINGS=true,
      FIREOPTIONS=2,
      OVERRIDEMODE=false,
      SHAREMINIMAPPROGRESS=true,
      SHOWFIREICONS=true,
      SHOWPLAYERICONS=true,
      SHOWPLAYERSOPTIONS=2 
    },
    enabled=true 
  },
  ["workshop-458587300"]={ configuration_options={ Ownership=false, Travel_Cost=32 }, enabled=true },
  ["workshop-666155465"]={
    configuration_options={
      chestB=-1,
      chestG=-1,
      chestR=-1,
      food_estimation=-1,
      food_order=0,
      food_style=0,
      lang="auto",
      show_food_units=-1,
      show_uses=-1 
    },
    enabled=true 
  },
  ["workshop-934638020"]={ configuration_options={  }, enabled=true } 
}
```
      
## 1.3. 使用方法
### 修改本项目
点击`fork`
      
#### 修改Dockerfile
```html
FROM ubuntu:18.04

此处省略
    && git clone https://github.com/yanxin152133/docker-dst.git \    更改这个链接
此处省略
```
      
#### cluster_token.txt
自行获取自己的`cluster_token.txt`文件
          
#### 服务器配置、mod
根据自己喜好修改相关配置
             
### 制作docker镜像
参考以下链接：
- [使用Docker Hub](https://doc.yonyoucloud.com/doc/chinese_docker/userguide/dockerhub.html)
        
### 1.3.2. 运行
```bash
## 拉取
docker pull yancccccc/dst:latest   # yancccccc/dst:latest 替换为自己的镜像名称

## 运行
docker run -itd --name dst -p 10889:10889/udp -p 10999:10999/udp -p 10998:10998/udp yancccccc/dst:latest   # yancccccc/dst:latest 替换为自己的镜像名称

## 10889、10999、10998三个端口可以修改Dockerfile自行设置，
## 同时对应的配置文件也需要进行更改，三个都为udp，
## 10889在配置主从服务器需要用到，10999、10998对应master、caves两个世界的端口
```
      
### 1.3.3. 查看运行日志
```bash
docker logs -t -f --tail 10 dst
## dst 对应自己设置的--name
```