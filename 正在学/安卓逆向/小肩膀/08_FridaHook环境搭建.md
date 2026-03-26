Hook就是可以覆写 可以函数 执行后 就触发Hook

# Python安装

首先你需要存在Python

这里我们先用Python3.8的

我这里是通过 Conda 进行Python的版本控制

```
conda create -n frida python=3.8
```

构建完毕调用即可

```
conda activate frida
```

# windows-frida安装

```
pip install frida
pip install frida-tools
```

只需要一行即可安装全部内容

那么我们验证一下是否安装成功

```
(firda) PS -> frida --version
17.8.3
(firda) PS -> python
Python 3.8.20 (default, Oct  3 2024, 15:19:54) [MSC v.1929 64 bit (AMD64)] :: Anaconda, Inc. on win32
Type "help", "copyright", "credits" or "license" for more information.
>>> import frida
>>>
```

如果输出内容和我差不多  也就没有报错 那么就是ok的

我们得到了 frida的版本 我们下载手机的服务端也必须是这个版本的`17.8.3`

```
https://github.com/frida/frida/releases
```

因为我这里还是虚拟机 所以我安装的是x86的

# vscode和nodejs安装

那么这里是编写我们 frida 代码的方法 其实也可以使用webstorm 当然看自己习惯

nodejs我使用nvm管理

```
https://code.visualstudio.com/
https://github.com/coreybutler/nvm-windows
```

```
nvm install 20
nvm use 20
node --version
```

如果输出的是`v20.20.2` 说明没问题

输入代码 如果输出`hello world`

```
function hello(){
    console.log("hello world");
}

hello()
```

安装好了 我们还需要添加 frida提示词

```
npm config set registry https://registry.npmmirror.com
npm i frida
npm i frida-java-bridge
npm i -D @types/frida-gum typescript
```

安装好了我们测试 输入`Inter` 是否会存在`Interceptor`的提示

如果安装有问题 记得加入代理

```
$env:HTTP_PROXY="http://127.0.0.1:7897"
$env:HTTPS_PROXY="http://127.0.0.1:7897"
$env:NO_PROXY="localhost,127.0.0.1"

npm config set proxy http://127.0.0.1:7897
npm config set https-proxy http://127.0.0.1:7897

git config --global http.proxy http://127.0.0.1:7897
git config --global https.proxy http://127.0.0.1:7897
```

![image-20260327011307740](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260327011307740.png)

# Android-frida-server安装

这个服务端是执行我们JS代码的并且是在手机端执行的

也就是我们把`JS`发送给`server `内置`fridaAgent.so` 注入对应进程 从而`HOOK`

首先我们确定我们的windows版本

`frida --version` 输出版本 我这里输出

`17.8.3`

选择自己的版本

```
https://github.com/frida/frida/tags
```

并且选择自己的架构 我这里是虚拟机 所以是`x86_64`

下载好了 那么所有的都构建完毕了 现在只需要 安装即可

```
adb push .\frida-server-17.8.3-android-x86_64 /data/local/tmp/fsx86
adb root
adb shell
> cd /data/local/tmp
> chmod 777 fsx86
> ./fsx86
```

那么这样就实现了 等待 那么我们下面验证是否成功 【注意窗口不要关闭】

```
 frida-ps -U
```

![image-20260327014010187](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260327014010187.png)

可以发现打印的是模拟器的进程 那么就说明 服务端配置完成 这个情况下 frida需要root权限

因为 代码注入主要依赖`zygote` 和`ptrace` 两个工作模式

如果是真机器 可以直接通过USB 连接 

如果是IP连接 或者模拟器的 那么需要端口转发

```
adb forward tcp:27042 tcp:27042
```

