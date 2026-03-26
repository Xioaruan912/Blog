# Charles抓包

首先对这个软件进行安装和激活

```
https://zzzmode.com/mytools/charles/
```

```
https://www.charlesproxy.com/
```

那就是直接安装即可 下面是证书的安装

默认是8888端口

![image-20260325174046841](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260325174046841.png)

那么这里的电脑端结束了

手机端安装`socksdroid` 从而让socks作为代理

```
https://github.com/bndeff/socksdroid/releases/tag/1.0.4
```

推送到 手机 记得需要`root`

```
adb install Desktop\socksdroid-1.0.4.apk
Performing Streamed Install
Success
```

打开后我们只需要关注前两个

![image-20260325174457561](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260325174457561.png)

修改为`charles`的`socks` 端口 默认`8889`

这里我们还需要保证 手机和电脑是在一个网下 我们可以电脑开启一个服务看看

```
python -m http.server
```

![image-20260325174701158](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260325174701158.png)

雷电的话就是去 设置中设置即可

![image-20260325174722290](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260325174722290.png)

可以的话我们直接开启代理即可

![image-20260325175026150](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260325175026150.png)

现在无法抓包是因为我们的证书啊 什么的都没正常配置 这个时候是可以正常抓取HTTP的包 

# TLS证书

现在基本的HTTP抓包环境就结束了 那么这里开始安装证书

去`proxy` 的`SSL proxy setting`

![image-20260325185612038](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260325185612038.png)这里还可以进行配置站点 我们直接抓取所有数据

![image-20260325185715260](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260325185715260.png)

`Charles` 的`help` ->SSL proxying -> 下载到手机

![image-20260325185452700](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260325185452700.png)

我们只需要通过代理`192.168.1.3:8888` 访问 `chls.pro/ssl` 即可 但是有可能是需要魔法

所以我们直接本地压入即可

我们选择`save root 证书`

我们推送到手机的`/sdcard/`

```
adb push Desktop\Desktop.pem /sdcard/
```

然后打开设置

![image-20260325190429023](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260325190429023.png)

然后点击从SD卡安装

![image-20260325190555162](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260325190555162.png)

安装即可 

# 证书移动到系统

**模拟器的配置有很多问题 如果可以还是需要真机**

有的应用是检测是否是系统证书  所以我们这里需要移动到系统中

用户证书：`/etc/security/cacerts`

系统证书：`/data/misc/user/0/cacerts` 

我们需要使用`Magisk` 的`Move Certificates`模块进行

如果是雷电模拟器 请使用下面教程

```
https://www.bilibili.com/video/BV1Er421W7J7/?vd_source=66a1e7f7d5a43d8999555b0f1ac9e57c
```

![image-20260325193709701](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260325193709701.png)

```
通过网盘分享的文件：Move_Certificates-v1.9.zip
链接: https://pan.baidu.com/s/1bCnO4JTEoGwTavwkJgyt8w?pwd=yujm 提取码: yujm 
--来自百度网盘超级会员v6的分享
```

安装好如下 （直接ZIP 安装即可 拖入共享文件夹 选择ZIP 即可）

然后我们可以去看看 我们的证书

![image-20260325193832257](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260325193832257.png)

可以发现用户证书都没了 因为都添加到了系统证书中了 这样检测是否是系统证书的就可以绕过了
