<#
## ? v6_y.ps1 脚本说明

===========================================================#
脚本名称：v6_y.ps1
脚本作者：Stephen Tseng | https://www.ynewtime.com
脚本功能：自动识别本机并配置网络为纯 IPv6
默认功能：v6_y.ps1 -->
 1. 默认不需要参数
 2. 自动识别当前时间是否为华工的断网时间
 3. 若为非断网时间，则配置电脑（1）开启 IPv6；（2）添加 HOST 内容
 4. 若为断网时间，则（1）禁用本地的 IPv4；（2）配置 IPv6 DNS 和 HOST
可选参数：v6_y.ps1 2 --> 
 *. 传入参数 2，则禁止本地所有网络适配器的 IPv6 功能，网络设置为纯 IPv4
补充说明：纯 IPv4 即平时非断网时段正常使用的情况（多数人并没有开启 IPv6）
亮点提示：纯 IPv6 + DNS + HOST 可以访问 Google 等支持 IPv6 协议的网站，测试成功有：
          Google系（搜索、邮箱、翻译、地图等） / Youtube / IPTV / Facebook
          Baidu / Bing / Github系（主页和Pages）/ Flickr / Tumblr
          Telegram系（Telegram + Telegraph）/ Bilibili（版权内）
          Reddit / Pinterest / 网易云（GPDR限制）/ UNSPLASH
最后更新：2018-09-12 08:52
============================================================#

## ? 功能描述

1. 自动识别系统时间
2. 如果在工作日凌晨六点之前（为华工的断网时间，断网时间 IPv4 被禁止，IPv6 正常工作），则：
 - （1）禁用 IPv4，修改 IPv6 DNS 为 NAT64 服务器 DNS
 - （2）配置 IPv6 HOST 为能够正确解析谷歌及其他国外热门IPv6站点地址的格式
3. 如果在工作日凌晨六点之后，或者周末，则：
 - （1）启用 IPv4，修改 IPv6 为 DHCP
 - （2）同样配置 IPv6 HOST
4. 如果是非华工学生使用，即贵校没有断网的情况下，请在白天运行该脚本一次即可。（后续会添加新的可选参数）
5. 注意，脚本使用的前提是当前的网络支持 IPv6

## ? v6_y.ps1 脚本使用

1. 使用默认功能：直接双击 v6_y.bat 即可；
2. 使用可选功能：
 - 按下快捷键 `win + x` 打开 Powershell，输入 `cd \脚本所在路径` 进入放置脚本的路径，接着输入 `.\v6_y.ps1 2` 即可启用可选功能
 - 按下快捷键 `win + r` 打开运行，输入 `cmd` 打开命令行，输入 `cd \脚本所在路径` 进入放置脚本的路径，接着输入 `Powershell .\v6_y.ps1 2` 即可启用可选功能

## ? v6_y.ps1 脚本注意

1、 文件夹中共有五个文件：

- v6_y.ps1 --> 主要的执行文件，编码格式为 GB18030，重要！
- setup.bat --> 一键脚本，双击运行即可，编码格式为 GB18030，重要！
- README.txt --> 此脚本的说明文件
- host --> IPv6 HOST 文件，重要！
- PACK.zip --> 源代码，UTF-8 编码

2、注意：

- 如需自行修改源代码，请解压 PACK.zip 中的文件进行操作
- 推荐使用 VScode 编辑器，可以方便地在底部的状态栏切换编码
- 重要！使用 VScode 编辑器切换编码时会弹出两个选项：
- （1）使用新的编码格式打开；（2）保存为新的编码格式
- 推荐使用 UTF-8 编码修改完所有的代码之后，另存为新的文件，再保存为 GB18030 编码
#>

# 设置输出信息
$out_put = "`
#===========================================================================================# `
# 脚本名称：v6_y.ps1 `
# 脚本作者：Stephen Tseng | https://www.ynewtime.com `
# 脚本功能：自动识别本机并配置网络为纯 IPv6 `
# 默认功能：v6_y.ps1 --> `
#  1. 默认不需要参数 `
#  2. 自动识别当前时间是否为华工的断网时间 `
#  3. 若为非断网时间，则配置电脑（1）开启 IPv6；（2）添加 HOST 内容 `
#  4. 若为断网事件，则（1）禁用本地的 IPv4；（2）配置 IPv6 DNS 和 HOST `
# 可选参数：v6_y.ps1 2 -->  `
#  *. 传入参数 2，则禁止本地所有网络适配器的 IPv6 功能，网络设置为纯 IPv4 `
# 补充说明：纯 IPv4 即平时非断网时段正常使用的情况（多数人并没有开启 IPv6） `
# 亮点提示：纯 IPv6 + DNS + HOST 可以访问 Google 等支持 IPv6 协议的网站，测试成功有： `
#           Google系（搜索、邮箱、翻译、地图等） / Youtube / IPTV / Facebook `
#           Baidu / Bing / Github系（主页和Pages）/ Flickr / Tumblr `
#           Telegram系（Telegram + Telegraph）/ Bilibili（版权内） `
#           Reddit / Pinterest / 网易云（GPDR限制）/ UNSPLASH `
# 最后更新：2018-09-12 08:52 `
#===========================================================================================# "

$out_put_1 = "`
#===================#`
选择：默认模式 `
等待：脚本执行中 `
状态：正在开启 IPv6 "

$out_put_2 = "`
选择：禁用模式 `
等待：脚本执行中 `
#===================#`
状态：正在禁用 IPv6 "

$root = Split-Path -Parent $MyInvocation.MyCommand.Definition # 获得当前脚本的路径
$hosts = $root + '\hosts'
$hosts_dir = "C:\windows\system32\drivers\etc\hosts" # 本机 hosts 文件的储存路径
# $hosts_url = "https://raw.githubusercontent.com/lennylxx/ipv6-hosts/master/hosts" 
# hosts文件版权遵循相应的项目LICENSE

# 如果传入的模式是 2，则关闭本机所有适配器的 IPv6 协议
if($args[0] -eq 2)
{
    # 通过另一个具备管理员权限的 Powershell 进程来运行脚本，避开管理员权限的率先获得，同时传入$args[0]以确保脚本正确运行
    If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
    {   
        $arguments = "& '" + $myinvocation.mycommand.definition + "'"
        Start-Process powershell -Verb runAs -ArgumentList $arguments,$args[0]
        Break
    }
    
    # 输出等待信息...
    echo $out_put
    echo $out_put_2

    # 关闭本机所有网络适配器的 IPv6
    Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6

    echo "状态：禁用 IPv6 成功"
    echo "状态：刷新 DNS 缓存"
    # 刷新本机的 DNS 缓存。
    ipconfig /flushdns | Out-Null
    echo "结果：DNS 刷新成功"
    echo "结果：禁用模式开启"

    # 输出当前网络配置信息
    echo "当前网络配置信息为："
    ipconfig

    Start-Sleep 5

    echo "结果：脚本执行成功"
    echo "等待 10s 自动关闭"
    Start-Sleep 10
}
# 如果传入的模式不是 2，则：
# 1. 首先开启本机所有适配器的 IPv6 协议
# 2. 根据本机当前的时间判断是否是华工的断网时间，
#    如果是，则（1）改变 DNS 为固定，（2）配置 HOST
#    如果不是，则（1）改变 DNS 为 DHCP，（2）配置 HOST
else
{
    # 通过另一个具备管理员权限的 Powershell 进程来运行脚本，避开管理员权限的率先获得。
    If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
    {   
        $arguments = "& '" + $myinvocation.mycommand.definition + "'"
        Start-Process powershell -Verb runAs -ArgumentList $arguments
        Break
    }

    # 输出等待信息...
    echo $out_put
    echo $out_put_1

    # 开启本机所有网络适配器的 IPv6 协议
    Enable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6
    echo "结果：开启 IPv6 成功"
    echo "#=====================#"
    
    # 刷新本机的 DNS 缓存。
    echo "状态：刷新 DNS 缓存"
    ipconfig /flushdns | Out-Null
    echo "结果：DNS 刷新成功"
    echo "#=====================#"

    # 如果当前系统时间处于周一至周五凌晨零点到六点的时间段，则：
    # 1. 更改本机 IPv6 DNS 为 240c::6644
    # 2. 设置本机 HOST 解析 IPv6 地址
    if( ((Get-Date).DayOfWeek -le 5) -and ((Get-Date).Hour -lt 6) ) 
    {
        # 时间和断网判断
        echo "本机当前时间为：", "$(Get-Date)"
        echo "状态：处于断网时间"
        echo "#=====================#"

        # 禁用本机所有网络适配器的 IPv4 协议，断网期间 IPv4 全栈被封，可以禁用，确保流量都走 IPv6 线路
        # 注意，禁用后如果在非断网时间需要重新开启，只需要再跑一遍 v6_y.ps1 就行了
        echo "状态：正在禁用 IPv4"
        Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip
        echo "结果：禁用 IPv4 成功"
        echo "#=====================#"

        # 更改本机所有适配器的 IPv6 DNS 为 240c::6644
        echo "状态：正在设置 IPv6 DNS"
        Get-DnsClientServerAddress -AddressFamily IPv6 |
        foreach {
            Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -Addresses '240c::6644'
        }
        echo "结果：IPv6 DNS设置成功"
        echo "#=====================#"

        # 设置 IPv6 HOST
        echo "状态：正在设置 IPv6 HOST"
        Copy-Item $hosts -Destination $hosts_dir -Force
        echo "状态：IPv6 HOST设置成功"
        echo "#======================#"
        echo "结果：IPv6 HOST设置成功"
        echo "#======================#"

        # 刷新本机的 DNS 缓存。
        echo "状态：刷新 DNS 缓存"
        ipconfig /flushdns | Out-Null
        echo "结果：DNS 刷新成功"
        echo "#================================#"
        echo "结果：纯 IPv6 环境已启动，玩得愉快"
        echo "#================================#"
        Start-Sleep 3

        # 输出当前网络配置信息
        echo "当前网络配置信息为："
        ipconfig

        Start-Sleep 5

        # 最后打开记事本查看本机的 HOSTS 文件是否已修改。
        echo "状态：打开记事本查看"
        Start-Process notepad -Verb runas -ArgumentList $env:windir\System32\drivers\etc\hosts

        echo "结果：脚本执行成功!"
        echo "#================================#"
        echo "等待 10s 自动关闭"
        Start-Sleep 10
    }
    # 如果当前系统时间处于周一至周五凌晨六点到晚上十二点，或周末这两个时间段，则：
    # 1. 更改本机所有适配器的 IPv6 DNS 为 DHCP
    # 2. 设置本机 HOST 解析 IPv6 地址
    else
    {
        # 时间和断网判断
        echo "本机当前时间为：", "$(Get-Date)"
        echo "状态：处于非断网时间"
        echo "#=====================#"     

        # 设置 IPv6 HOST
        echo "状态：正在设置 IPv6 HOST"
        Copy-Item $hosts -Destination $hosts_dir -Force
        echo "状态：IPv6 HOST设置成功"
        echo "#=====================#"
        echo "结果：IPv6 HOST设置成功"
        echo "#=====================#"

        # 启用本机所有网络适配器的 IPv4 协议
        echo "状态：正在启用 IPv4"
        Enable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip
        echo "结果：启用 IPv4 成功"
        echo "#=====================#"

        # 更改本机所有适配器的 IPv6 DNS 为 DHCP
        echo "状态：正在设置 IPv6 DHCP"
        Get-DnsClientServerAddress -AddressFamily IPv6 |
        foreach {
            Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -ResetServerAddresses
        }
        echo "结果：IPv6 DHCP设置成功"
        echo "#=====================#"

        # 更改本机所有适配器的 IPv4 DNS 为 8.8.8.8, 4.4.4.4
        echo "状态：正在设置 IPv4 DNS"
        Get-DnsClientServerAddress -AddressFamily IPv4 |
        foreach {
            Set-DnsClientServerAddress -InterfaceIndex $_.InterfaceIndex -Addresses '8.8.8.8','4.4.4.4'
        }
        echo "结果：IPv4 DNS设置成功"
        echo "#=====================#"

        # 刷新本机的 DNS 缓存。
        echo "状态：刷新 DNS 缓存"
        ipconfig /flushdns | Out-Null
        echo "结果：DNS 刷新成功"
        echo "#================================#"
        echo "结果：纯 IPv6 环境已启动，玩得愉快"
        echo "#================================#"

        # 输出当前网络配置信息
        Start-Sleep 3
        echo "当前网络配置信息为："
        ipconfig

        Start-Sleep 5

        # 最后打开记事本查看本机的 HOSTS 文件是否已修改。
        echo "状态：打开记事本查看"
        Start-Process notepad -Verb runas -ArgumentList $env:windir\System32\drivers\etc\hosts

        echo "结果：脚本执行成功!"
        echo "#================================#"
        echo "等待 10s 自动关闭"
        Start-Sleep 10
    }
}
