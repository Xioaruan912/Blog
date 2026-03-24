这里介绍的是Android的基本内容 和虚拟机啊等其他内容

# Android历史

在 Android 4.4以前 采用的是`dalvik/dvm虚拟机` 主要特征是系统中存在`libdvm.so`

在 Android 4.4  采用的是`dvm虚拟机`和`art虚拟机` 主要特征是系统中存在`libdvm.so`和 `libart.so`

在 Android 5.0  采用的是`art虚拟机` 主要特征是系统中存在 `libart.so `并且区分32位和64位

这个就是基本的Android 发展历史

那么现在都是使用`art虚拟机`了

# APK架构

我们做逆向 肯定是需要了解APK有什么东西才可以继续逆向 所以这里查看一下架构

`AndroidManifest.xml` 这是我们APK的核心配置文件 所有的权限 入口函数 进程名字都是定义在其中的

![image-20260324104237961](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260324104237961.png)

`class.dex` 这是Java逆向的主要内容 也就是我们的源代码 但是其实在jadx中已经在源代码区域反汇编出来了

![image-20260324104331649](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260324104331649.png)

`resources.arsc` 是打包后的资源包

`META-INF` 这个目录是我们的签名信息 只有签名了 才允许安装到安卓系统中

`res` 这个目录保存的是图片 音频 还有布局信息相关的信息 如果我们打开其实是编译过的

`assets` 这个目录保存的是没有编译的 图片视频信息

`lib` 这个目录保存的是 我们的so文件 也就是我们的依赖库 是需要拖入IDA进行分析的

以上就是基本没有加壳前的项目结构

# 安卓架构

```
https://developer.android.com/guide/platform?hl=zh-cn
```

![img](https://raw.githubusercontent.com/Xioaruan912/pic/main/68747470733a2f2f692e6c6f6c692e6e65742f323031392f30342f32322f356362643731343333663462662e706e67)

上述图片就是我们基本的安卓架构

##### Linux 内核层

最底层就是我们的Linux内核相关 用于维护硬件和软件之间的通道 属于OS Linux 内核的安全机制为 Android 提供了相应的保障

##### 硬件抽象层 HAL

向更高级别的 Java Framework 层显示设备硬件功能

框架 API 要求访问设备硬件时，Android 系统将为该硬件组件加载库模块

##### Native C/C++ 库 && Android Runtime

ART 通过执行 DEX 文件可在设备上运行多个虚拟机

##### Java Framework 层

保存着Java的API 然后就会下传到下层

##### System Apps 层

也就是我们的 应用层面 主要就是Java代码



那么以上我们就可以知道 我们使用Linux基本命令 其实在`adb shell `中都可以使用

# 安卓目录

那么这里是我们安卓基本的目录相关

#### DATA目录

`data/data` 存放的是用户的APK数据 每个APK 都有自己的目录 并且按照包名命名 每个APK都只可以访问自己的目录 除非`root` 也就是只可以自己的目录运行

```
:/data/data # ls | grep app.np
com.wn.app.np
```

`data/app` 用户安装的APK

后面是随机值 每次安装都不同 这里存放的是用户自己安装的内容

```
:/data/app # ls
com.android.flysilkworm-gEMev7pwhOUN5vSe2gs7ZQ==
com.android.launcher3-VkII8gPUm-3klkQnWwLn4w==
com.topjohnwu.magisk-H5LATSczisLA2obDvqjXSw==
com.wn.app.np-SPIBgyWh1iv8-rPatxT_cQ==
:/data/app #
```

那么这个目录下还有基本层级

`base.apk` ：基本的APK

`icons` ：图标

`lib`：使用到的so文件存储在这里

`oat` ：dex文件转化为其他要使用的文件

`data/local/tmp` 权限很大 可以直接推送进入  我们不需要`adb root` 即可直接推入

#### system目录

`system/app` 这里存储的是 系统自带的APP 一般需要`root`权限相关

`system/lib ` 和`system/lib64` 存放的是APK会使用到so文件

`system/bin` 存放的是我们基本的Linux命令

```
2|:/system # cd bin/
:/system/bin # ls
acpi                ifconfig              reboot
adbd                ime                   renice
am                  incident              requestsync
app_process         incident_helper       resize2fs
app_process32       incidentd             restorecon
app_process64       inotifyd              rm
applypatch          input                 rmdir
.....................................................
```

`system/framework`  存放的是Android系统所用到的框架 基本是jar包 也就是Java层的API

#### SD卡

无论手机是否有存储卡 都会存在这个目录 

APP操作SD卡的时候 需要申请权限

安卓 6.0以下需要在配置清单中申请权限

安卓 6.0以上需要在代码动态申请

安卓 10.0以上需要前面两个基础上依旧在清单中配置

`sdcard`其实是一个软连接

```
lrw-r--r--   1 root   root        21 2026-03-17 10:35 sdcard -> /storage/self/primary
```

还存在在

```
/mnt/sdcard
/storage/emulated/0/
```

都是可以进入SD卡

# Linux权限

学习完基本的内容 我们还需要学习一下权限控制相关的

我们通过`ls -al` 展示出来的时候 会存在权限内容 比如上面的`lrw-r--r-- `

第一位确定 文件类型

```
- 是普通文件
l 是连接文件 如果是那么就会在后面打印出  -> 
d 是目录
c 是设备文件 鼠标键盘等
b 是块文件 硬盘 /dev
```

2-4位确定 所有者应用该文件的权限

5-7位确定 所属组拥有该文件的权限

8-10位确定 其他用户对该文件的权限

那么权限表示`rwx` 

其中`r` 是读 `w` 是写 `x` 是执行 `-` 是没有权限

可以使用数字来进行`r=4 w=2 x=1`

```
1 root   root 
```

第一个是 硬链接数 文件一般是1 目录一般是2

所属root用户和root组