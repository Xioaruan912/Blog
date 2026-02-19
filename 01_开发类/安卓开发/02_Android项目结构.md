整个安卓结构如图所示

![image-20260120190312262](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120190312262.png)

`Java`为核心代码 `MainActivity` 为主要入口 Java核心代码

`Res`为资源文件 主要图片 展示界面 都是在这里的

`Gradle Scripts` 为构建脚本

# APP

我们看看`app` 下面的内容

![image-20260120191320424](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120191320424.png)

`build`：是写完程序的 APK 都会生成 在 `build` 文件夹

`src`：是我们代码的核心内容

`androidTest`：用于安卓测试 

`main`：主要核心代码处

`res`：内容很多 等等介绍

`AndroidManifest.xml`：清单文件 主要 注册组件和权限以及图标内容的设置

`test`：单元测试用的

`build.gradle.kts`：APK模块的构建脚本

`proguard-rules.pro`：项目代码的混淆规则

`libs`：如果我们使用第三方 内容 那么就会存入 `libs`中

## res

![image-20260120191453599](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120191453599.png)

这里 `drawable` 主要放图片 `layout` 主要存储布局 `mipmap` 主要放图标 不同屏幕的处理 `values`是 颜色 主题等 `values-night` 也就是夜间模式

这样整个项目构建就结束了



1. 所以我们其实发现 主要核心 是 `src` 内部的 代码为主要核心 我们后面也是围绕这个操作

