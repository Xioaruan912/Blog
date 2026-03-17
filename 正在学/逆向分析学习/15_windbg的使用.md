`windbg`是可以用于 调试内核程序的 所以我们很需要学习 微软官方出品的

https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/

需要开启 `tun模式 `访问外网下载

![image-20260202184029231](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260202184029231.png)

# 命令

`windbg`无可替代 主要也就是有 命令的加持 我们可以通过 `F1`打开帮助手册 查看命令

## 断点相关

`bp`：下断点 可以跟地址 函数名字 `bp kernel32!CreateProcessW` 或者对一系列下断点 `bp kernel32!CreateProcess*` 

`bu`：给没有解析好的地址 下断点 也就是不知道是什么模块

`bl`：查看断点列表

`bc`：清除断点

`bd`：禁用断点 跟序号

`be`：启用断点 跟序号

## 数据相关

`da`：通过ASCII方式查看内存

`db`：用ASCII和十六进制同时查看内存

`dc`：四字节和ASCII 同时查看内存

`dd`：四字节DWORD查看

`dw`：两个字节WORD查看

`du`：通过UNICODE 查看

`dp`：通过指针查看内存 32位下和`dd`相同

`dds`：通过4字节查看并且查找符号信息 可以快速匹配

## 搜索

`x`：可以查找某个模块下的所有函数 `x kernel32!Create` 查找`Create`开头的所有函数

`r`：查看寄存器的值

`u`：反汇编某个地址

`kv`：查看调用堆栈

`lm`：查看模块列表

`.cls`：清屏

# dump分析

当程序错误 蓝屏 如果配置了dump 就可以输出一个 `.dmp`的文件 从而可以分析

```
!analyze -v xxx.dmp
```

# 内核调试

研究内核相关 和 驱动开发 一般是通过下述方法进行

![image-20260202185235410](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260202185235410.png)

# 时间旅行调试

我们通过以前的方法是 调试完毕后 重新启动调试 从而实现 第二次的查看 但是有些内容是 只可以偶发性的调试 不会经常出现 那么如何操作

`windbg` 可以通过时间旅行调试方法 在 一次环境中 不断调试

从而可以不断前进 后退实现调试

![image-20260202185604242](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260202185604242.png)