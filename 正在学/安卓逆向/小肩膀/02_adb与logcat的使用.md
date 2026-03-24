# adb

这是维持我们PC和手机或者模拟器的通道 那么这里需要具体了解一下如何使用

`abd help` :如果你忘记了 那么就可以通过`help`查看命令

`adb devices` ：枚举当前可操作的设备列表

`adb -s 设备 shell` ：指定某个设备进行连接 【在多设备的时候】 如果只要一个就会默认进

![image-20260324100534310](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260324100534310.png)

那么上述就是连接我们的设备 那么下面是对软件的安装

`adb install APK路径`：把APK 安装到我们设备中

`adb -r install APK路径`：把APK 覆盖安装到我们设备中

`adb uninstall 包名`：注意这里卸载是需要通过包名的 我们可以通过`jadx` 查看

![image-20260324100446405](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260324100446405.png)

那么我们对数据文件的拉去和上传 也可以进行

`adb push 电脑路径 安卓路径 ` ：这个就是把我们本地文件上传到Android系统中 一般推送到`/sdcard/`

`adb pull 安卓路径 电脑路径  ` ：这个就是把Android系统中的文件发送到电脑中

# logcat

类似我们的日志 会保存在手机内部 我们可以通过` adb logcat` 捕获出来

![image-20260324102016531](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260324102016531.png)

当然我们需要的是我们app内部信息

那么首先学的是基本的命令

`adb logcat -help` ：展示帮助信息

`adb logcat` ：常规展示

`adb logcat -c`：清空日志

`adb logcat -g`：显示缓冲区大小

`adb logcat -G 256M`：修改缓冲区大小

`adb logcat -v time`：设置不同的展示格式

`adb logcat -v color`：带颜色

上述是我们常规的设置 那么我们下面需要学习过滤的方法

`abd logcat -s tag内容 ` ：因为我们通过代码输出的时候 是需要写入`tag`的 我们可以通过`tag`定位

![image-20260324102704262](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260324102704262.png)

那么我们还可以配合命令行进行 win和Linux都是不同的 我们可以通过下面的方法配合

```
abd shell
ps -A | grep com.wn.app.np				//这里获得PID
exit
adb logcat | findstr PID
```

但是一般情况下我们使用 Android Studio 中也存在`logcat`

![image-20260324103508837](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260324103508837.png)