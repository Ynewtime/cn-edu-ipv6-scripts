## 📌IPv6 自动化脚本

### 🔨 v6_y.ps1 脚本说明

**脚本名称**：v6_y.ps1  
**脚本作者**：[Stephen Tseng](https://www.ynewtime.com)  
**脚本功能**：自动识别本机并配置 IPv6 环境  
**默认功能**：`v6_y.ps1` -->  
 1. 默认不需要参数  
 2. 自动识别当前时间是否为华工的断网时间  
 3. 若为非断网时间，则配置电脑（1）开启 IPv6；（2）添加 HOST 内容  
 4. 若为断网时间，则（1）禁用本地的 IPv4；（2）配置 IPv6 DNS 和 HOST  

**可选参数**：`v6_y.ps1 2` --> 传入参数 2，则禁止本地所有网络适配器的 IPv6 功能，网络设置为纯 IPv4  
**补充说明**：纯 IPv4 即平时非断网时段正常使用的情况（多数人并没有开启 IPv6）  
**亮点提示**：纯 IPv6 + DNS + HOST 可以访问 Google 等支持 IPv6 协议的网站，测试成功有：  
          [Google](https://www.google.com)系（搜索、邮箱、翻译、地图等） / [Youtube](//www.youtube.com) / [IPTV](//iptv.tsinghua.edu.cn) / [Facebook](//www.facebook.com)  
          [Baidu](//www.baidu.com) / [Bing](//www.bing.com) / [Github](//github.com)系（主页和Pages）/ [Flickr](//www.flickr.com) / [Tumblr](//www.tumblr.com)  
          Telegram系（[Telegram](//telegram.org) + [Telegraph](//telegra.ph) / [Bilibili](//www.bilibili.com)（版权内）  
          [Reddit](//www.reddit.com) / [Pinterest](//www.pinterest.com) / [UNSPLASH](//unsplash.com/collections)  
**最后更新**：2018-09-12 20:52  

### 🔨 功能描述

1. 自动识别系统时间
2. 如果在工作日凌晨六点之前（为华工的断网时间，断网时间 IPv4 被禁止，IPv6 正常工作），则：
 - （1）禁用 IPv4，修改 IPv6 DNS 为 NAT64 服务器 DNS
 - （2）配置 IPv6 HOST 为能够正确解析谷歌及其他国外热门IPv6站点地址的格式
3. 如果在工作日凌晨六点之后，或者周末，则：
 - （1）启用 IPv4，修改 IPv6 为 DHCP
 - （2）同样配置 IPv6 HOST
4. 如果是非华工学生使用，即贵校没有断网的情况下，请在白天运行该脚本一次即可。（后续会添加新的可选参数）
5. 注意，脚本使用的前提是当前的网络支持 IPv6

### 🔨 v6_y.ps1 脚本使用

1. 使用默认功能：直接双击 v6_y.bat 即可；
2. 使用可选功能：
 - 按下快捷键 `win + x` 打开 Powershell，输入 `cd \脚本所在路径` 进入放置脚本的路径，接着输入 `.\v6_y.ps1 2` 即可启用可选功能
 - 按下快捷键 `win + r` 打开运行，输入 `cmd` 打开命令行，输入 `cd \脚本所在路径` 进入放置脚本的路径，接着输入 `Powershell .\v6_y.ps1 2` 即可启用可选功能

### 🔨 v6_y.ps1 脚本注意

1、 文件夹中共有五个文件：

- **v6_y.ps1** --> 主要的执行文件，编码格式为 GB18030，重要！
- **setup.bat** --> 一键脚本，双击运行即可，编码格式为 GB18030，重要！
- **README.txt** --> 此脚本的说明文件
- **host** --> IPv6 HOST 文件，重要！
- **PACK.zip** --> 源代码，UTF-8 编码

2、**注意**：

- 如需自行修改源代码，请解压 PACK.zip 中的文件进行操作
- 推荐使用 VScode 编辑器，可以方便地在底部的状态栏切换编码
- 重要！使用 VScode 编辑器切换编码时会弹出两个选项：
-- （1）使用新的编码格式打开；
-- （2）保存为新的编码格式
- 推荐使用 UTF-8 编码修改完所有的代码之后，另存为新的文件，再保存为 GB18030 编码
