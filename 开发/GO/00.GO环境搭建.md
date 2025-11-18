# 安装GO

```
https://go.dev/dl/
```

下载安装即可

# 环境配置

一般来说都默认添加好了 所以如果CMD 输出了 就不需要管这个了

Path中 添加 

```
%USERPROFILE%\go\bin
```

CMD go version

```
PS C:\Users\12455> go version
go version go1.24.5 windows/amd64
PS C:\Users\12455>
```

这样其实实际上就配置结束

# IDE

可以选择 GOLAND 或者 通过VSCODE 实现 

但是推荐 使用GOLAND 毕竟是专门使用的IDE

## 下载GOLAND

https://www.jetbrains.com/go/download/?section=windows

如已安装，先卸载旧版本，重启电脑，安装新版本

安装后以后不要运行程序。

## 激活IDE

下载下面的内容

```
通过网盘分享的文件：ckey_run.zip
链接: https://pan.baidu.com/s/1MQ9chmzJSZM1kCUstjv1aQ?pwd=bcmy 提取码: bcmy 
--来自百度网盘超级会员v6的分享
```

**下载 脚本 存入一个不移动的位置 并且不允许有中文**

```
# Windows：执行 脚本中\scripts\install-all-users.vbs
# Linux/MACOS：执行 脚本中\scripts\install.sh
```

首次启动时会出现激活框，复制激活文件中对应的软件激活码激活即可；

新版本软件不会自动弹出激活，点击【设置 → 管理订阅】能看到未激活信息，

手动选择激活码，复制激活即可，goland 和code with me 都可以激活。