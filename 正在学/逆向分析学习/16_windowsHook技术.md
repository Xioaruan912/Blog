我们学习过JSHook 由于本地浏览器权限最大 所以我们可以通过 本地把 函数 重写 从而实现自己的内容和 hook

现在是windows 的hook过程

`hook`：钩子 通过编程 改变计算机执行过程的技术

可以通过 修改关键函数 从而达到监听 与 渗透

# inline Hook

通过修改函数指令 实现hook 是最基本的hook方法

也可以认为是打补丁

# IAT Hook

除了修改函数指令 我们还可以修改函数地址

导入地址表的 hook

通过修改 函数表的内容 让表内指向其他函数 从而达到劫持

![image-20260202203220272](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260202203220272.png)

# 虚函数hook

我们之前学习过 虚函数 可以通过 构造虚函数的 地址 从而 hook

![image-20260202203302096](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260202203302096.png)

# SEH HOOK

我们之前 反调试检测 也有用SEH 检测

```
__try{

}__except(){

}
```

主要是 FS 指向的 `TEB`中 存在一个 `ExceptionList` 

保存着 对于 异常处理的函数 

![image-20260202203435741](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260202203435741.png)

我们可以hook住 异常处理

# windows消息 hook

我们知道 都是通过消息函数 处理 我们可以通过 官方的 `setWindowsHookExA` 实现hook

![image-20260202203559104](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260202203559104.png)

# SSDT HOOK

`kernel32` `user32` 这些库的函数 一般都是进一步调用 `ntdll` 的函数 一般按照NT 开头的都是 从系统 进入 内核态的函数

![image-20260204194526212](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260204194526212.png)

SSDT表就 记录了所有系统调用函数的入口函数 通过修改 那么就可以直线`hook`

一般守护安全的工具 都是通过 `hook`  `SSDT表 ` 通过监控` SSDT` 的系统调用 从而保证 敏感API没有被调用

# IDT HOOK

在x86架构上 中断处理函数的地址保存在 IDT表中 我们可以hook这个地址 执行我们编写的内容

其实从 win7的 64位开始 引入了 内核保护补丁 不允许hook这些敏感数据结构

# IRP HOOK

主要是通信程序

![image-20260204194846340](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260204194846340.png)

# TDI HOOK 、 NDIS HOOK

主要是网络通信的hook方法 用于监控传输 信息

![image-20260204194933279](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260204194933279.png)

`SSDT IDT IRP TDI NDIS` 这些`hook`方法 需要编写驱动程序 从内核下 监控内容

