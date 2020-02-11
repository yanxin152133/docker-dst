# Linux服务器要求
- 上行带宽：8KBps 一个玩家；
- 内存：差不多一个玩家 65Mbytes；
- CPU：没太大要求

<!--more-->
# 服务器端口开放
**默认情况下，服务器在端口10999上使用UDP流量**
      
因此需要将服务器的10999端口进行开放
       
# 内存
为了防止内存不足，开启SWAP。
      
- 首先确认SWAP设置了多少 
         
```bash
free -m
```
        
- 如果觉得不满意其空间大小，则对SWAP进行删除
       
```bash
swapoff -a

```
        
- 新增SWAP分区
        
```bash
dd if=/dev/zero of=/root/swapfile bs=1M count=1024
  #1024大小可根据自己情况进行更改
```
       
- 格式化交换分区文件
       
```bash
mkswap /root/swapfile
```

- 启用swap分区文件

```bash
swapon /root/swapfile
```

- 添加开机启动
      
```bash
vi /etc/fstab
```

这里提一下vi编辑器的基本用法：      
进入文本后按键盘上的insert按钮开始编辑，按esc退出编辑，输入:wq保存并退出。           

1. 添加或修改

```bash
/root/swapfile swap swap defaults 0 0
```

2. 重启下是否生效
      
```bash
reboot
```
      
3. 重启后输入指令查看下SWAP是否增加
      
```bash
free -m
```
       
# 依赖安装
```bash
# Ubuntu
$ sudo apt-get install libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 lib32gcc1
# CentOS(仅供参考)
$ yum -y install glibc.i686 libstdc++.i686 libcurl4-gnutls-dev.i686 libcurl.i686
```
        
# 安装 SteamCMD
SteamCMD，顾名思义，就是 Steam 的命令行版本。虽然饥荒服务器本身并不需要用 Steam 进行验证啊之类的，但我们还是得用它来把服务器更新到最新版本，不然其他人是进不来的。
         
我们最好新建一个用户来运行 SteamCMD，如果直接用 root 用户运行游戏服务端的话可能会导致严重的安全隐患。在 root 权限下使用以下命令来创建一个新用户： 
       
```bash
$ useradd -m steam
$ su - steam
```
       
然后在你喜欢的地方创建一个为 SteamCMD 准备的目录：
      
```bash
$ mkdir ~/steamcmd  ## 创建目录
$ cd ~/steamcmd  ## 进入该目录
```
        
下载并解压 Linux 专用的 SteamCMD：
      
```bash
$ wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz  ##  下载
$ tar -xvzf steamcmd_linux.tar.gz  ## 解压
```
       
运行 SteamCMD：
      
```bash
$ ./steamcmd.sh
```
         
登录安装退出操作：
      
```bash
# 匿名登录，没必要用用户名密码登录
login anonymous
# 这里我们强制要 Steam 把饥荒服务端安装到此目录下
# 最好用绝对路径，否则可能会安装到奇怪的地方去
force_install_dir ../dontstarvetogether_dedicated_server
app_update 343050 validate
quit
```
      
安装完成后，使用 quit 命令退出 steam 程序。
          
- 成功安装所出现的标志：
       
```bash
Success! App '343050' fully installed.
```
     
# 通过客户端获取配置文件
## 服务器端配置文件位置及相关操作
饥荒的配置目录位于: **~/.klei/DoNotStarveTogether**
        
然后手动创建一个存档目录：     
       
```bash
mkdir -p ~/.klei/DoNotStarveTogether/MyDediServer
```

## 利用客户端创建世界
1. 进入游戏
2. 创建自己的世界，设置可自定应。
3. 以 Windows 为例（Linux/Mac 类似），存档位置位于 **/Users/username/Documents/Klei/DoNotStarveTogether**，也就是文档目录下。
4. 在该目录的下一级目录中，在一个**全是数字的文件夹**中有一个命名为 Cluster_X 的文件夹（X 为数字编号），提取出刚刚创建的存档。
       
## 修改配置文件
**cluster.ini**

修改**bind_ip**和**master_ip**内容       
```
[SHARD]
shard_enabled = true
bind_ip = 0.0.0.0 
master_ip = 你的主服务器的 IP 
```
     
## Mod
进入到服务器的的饥荒安装目录：
       
```bash
cd ~/dontstarvetogether_dedicated_server/mods
```
     
修改该目录下的 dedicated_server_mods_setup.lua 文件：
       
```bash
vim dedicated_server_mods_setup.lua 

# 在该文件中添加类似这样的内容，这串 ID 是 Mod 文件在 Steam 中的 ID
# 可以在提取到的配置文件的 Master/modoverrides.lua 中找到
# 然后添加到本文件中，一行一个
ServerModSetup("362175979")
```
      
本教程模板：    
     
```lua
ServerModSetup("1089344410")
ServerModSetup("1146082006")
ServerModSetup("1200745268")
ServerModSetup("1207269058")
ServerModSetup("1290228121")
ServerModSetup("1301033176")
ServerModSetup("352499675")
ServerModSetup("362175979")
ServerModSetup("375850593")
ServerModSetup("378160973")
ServerModSetup("380423963")
ServerModSetup("444235588")
ServerModSetup("458587300")
ServerModSetup("462434129")
ServerModSetup("488009136")
ServerModSetup("577104313")
ServerModSetup("622448972")
ServerModSetup("666155465")
ServerModSetup("682721879")
ServerModSetup("785295023")
ServerModSetup("841471368")
ServerModSetup("892478248")
ServerModSetup("934638020")
```
       
## 上传配置文件
将配置文件上传到 **~/.klei/DoNotStarveTogether/MyDediServer**下
        
Linux传输文件可参考链接：     
- [Linux scp命令](https://www.runoob.com/linux/linux-comm-scp.html)
- [Linux下如何将一个用户下的文件拷贝到另一个用户里](https://blog.csdn.net/chenjianqi0502/article/details/69943915)
- [Linux中zip压缩和unzip解压缩命令详解](https://www.cnblogs.com/dump/p/7716823.html)
        

# 配置user_id和自己的token
搭建服务器需要相关的管理人员以及相关token文件
      
1. 获取相关文件
进入 https://accounts.klei.com/account/info  该链接
        
2. 按图中步骤进行操作
首先获取用户id,下图中的箭头所指的即是用户id，复制之后作为设置管理员文件的信息。
        
![](https://live.staticflickr.com/65535/48404433496_87c7015b3f_z.jpg)
       
点击 **导航栏** -- **游戏** -- **Don't Starve Together Server**
       
![](https://live.staticflickr.com/65535/48404433451_ba62f3135c_z.jpg)
        
下图中三个箭头所指的东西任选其一即可，同时最下方也可以支持添加。复制作为token。
![](https://live.staticflickr.com/65535/48404582862_0cc950201d_z.jpg)
       
3. 编辑相关文件
先新建 cluster_token.txt 文件，再将此前获取到的 Token 复制到文件中。
        
```bash
touch cluster_token.txt
```
        
再新建 adminlist.txt 文件，再将此前获取到的 UserID 复制到文件中。
        
```bash
touch adminlist.txt
```
            
# 启动游戏
## 启动脚本
创建脚本文件:
     
```bash
cd ~ && touch startDST.sh
```
      
编辑脚本文件:
      
```bash
#!/bin/bash
steamcmd_dir="$HOME/steamcmd"
install_dir="$HOME/dontstarvetogether_dedicated_server"
cluster_name="MyDediServer"
dontstarve_dir="$HOME/.klei/DoNotStarveTogether"
cd "$install_dir/bin"
run_shared=(./dontstarve_dedicated_server_nullrenderer)
run_shared+=(-console)
run_shared+=(-cluster "$cluster_name")
run_shared+=(-monitor_parent_process $$)
"${run_shared[@]}" -shard Caves  | sed 's/^/Caves:  /' &
"${run_shared[@]}" -shard Master | sed 's/^/Master: /'

```
       
给启动脚本添加权限：
        
```bash
chmod +x ./startDST.sh
```
       
运行：    
      
```bash
./startDST.sh
```
        
# 更新游戏版本
创建脚本文件：    
      
```bash
cd ~ && touch updateDST.sh
```
       
编辑脚本文件：    
       
```bash
#!/bin/bash

steamcmd_dir="$HOME/steamcmd"

## 检查并更新更新游戏版本
cd "$steamcmd_dir"
./steamcmd.sh +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 +login anonymous +force_install_dir ../dontstarvetogether_dedicated_server +app_update 343050 validate +quit

```
       
给脚本添加权限：    
      
```bash
chmod +x ./startDST.sh
```
       