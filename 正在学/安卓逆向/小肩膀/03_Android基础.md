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