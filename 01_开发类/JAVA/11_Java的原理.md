# 运行机制

`java` 写出来的代码 为 `name.java`

通过编译 构架 字节码文件 `name.class`

并且通过 `name.class`运行 并且运行在 `java虚拟机`中的

从而实现 `跨平台`操作

![image-20260120153405266](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120153405266.png)

在 `jdk` 安装后 就已经安装了 `JVM`

# 内存和内存地址

内存是程序运行的地方

一个变量 有唯一的 内存地址

# 内存分配规则

JVM包含下面的内容

1.栈内存： 每个线程都有自己的独立栈 方法调用入栈 执行完毕出栈

2.堆内存： 线程 共享堆内存 是通过 `new` 声明出来的

3.方法区：存储在本地内存中 存储 `class`字节码信息，常量和静态变量

4.本地方法栈： 调用本地Native方法

5.程序计数器： 记录当前代码执行到第几行

![image-20260120154055412](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120154055412.png)

![image-20260120154321629](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120154321629.png)



这里传递过程 是 值拷贝传递 所以 声明周期 是方法内部的

# 数组在内存中的传递过程

通过`new` 方法返回的是 指针 所以

![image-20260120154521080](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120154521080.png)

对于 `arr` 来说 是 引用数据类型

所以数组如何传递呢 数组传递的是 引用数据类型 所以在不同方法中 修改 的都是一个 数组

![image-20260120154646297](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260120154646297.png)