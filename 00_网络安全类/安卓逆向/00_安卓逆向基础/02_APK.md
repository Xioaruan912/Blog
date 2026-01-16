首先学习 APK的 结构 和一些内容

# APK的文件结构

APK具有严格的 文件结构 我们在Win中 可以直接通过 解压缩软件 打开 

![image-20260115221548460](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115221548460.png)

| 文件/目录           |                                                              |
| ------------------- | ------------------------------------------------------------ |
| assets目录（可选）  | 主要用于存放 图片 视频 等 静态文件                           |
| lib目录（可选）     | 存放 so文件 也就是   c 或者c++编译的 动态链接库文件          |
| META-INF目录        | 保存签名信息文件目录 类似 APK的完整性                        |
| res目录             | 存放 资源文件 图片 字符串等 APK展示主要通过目录中的 layout文件设计 |
| AndroidMainfest.xml | APK的应用清单 主要描述了 名字 版本 权限和引用库文件信息等    |
| classes.dex         | 主要是 JAVA 编译后的java二进制文件 是安卓的核心              |
| resources.arsc      | resources.arsc是编译后的二进制文件 主要映射资源对应ID 通过R文件中的ID找到对应资源 |

# 逆向流程图

![image-20260115225711712](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260115225711712.png)

这就是简单的 逆向流程图
