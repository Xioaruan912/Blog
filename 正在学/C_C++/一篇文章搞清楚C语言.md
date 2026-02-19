C语言 构建了整个 计算机世界

所以C 是我们必须要学习的 

我们的学习 这里是快速 过一遍 概念 然后学C++ 最后通过实战编程 巩固内容

# 区别其他语言

C具有区别于其他语言的"*弊端*" 

类似Java Python 编程人员很少会去关注 指针 内存方面的内容 更多关注的是 业务逻辑上的流畅

底层细节都被屏蔽了 对于普通开发人员 当然越高级越好 

但是对于逆向分析 C语言是优于 其他高级语言的 

1. 需要频繁和 栈 堆 内存打交道
2. 并且需要基于操作系统原生的API 编程 无法进行跨平台
3. 可以访问内存

难度对比其他高级语言就上升了

![image-20260217224134693](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260217224134693.png)

所以我们学习好C 需要学习下面的内容

# 学习过程

1. 底层内存原理
2. 了解计算机和操作系统
3. 看见一段C 脑子可以自动推演执行过程 才算可以
4. 结合汇编学习

那么具体的学习路线是什么呢

1. 语法
2. 基础编程 （控制台程序）
3. 数据结构和算法
4. 操作系统相关
5. 系统编程 （线程 进程 IPC 异步同步 内存） Win32编程
6. 中大型实战开发

# 计算机执行过程的本质

遵循芬诺伊曼计算机架构实现 通过内存读入CPU 实现运行

编程语言通过 编译器 把人类理解的语言 转化为 机器了解的内容 从而执行

# 链接过程

![image-20260217225018639](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260217225018639.png)

这里注意 

1. 预处理是对一些 宏定义或导入内容进行处理
2. 编译是把C编译成汇编文件
3. 汇编是把汇编文件 转化为 01指令（机器指令）
4. 链接是合并 最终的exe文件

# 常量和变量

定义数据格式如下

```
数据类型 名字 = 值;
int a = 10;
```

如果对于不允许修改的内容

```c
const int a = 10;
```

那么后续无法对` a `进行任何修改 （编译层面）

对于常量 也就是一个不可修改的固定

```c
#define PI 3.14
```

# 数据类型

| 名字         | 数据类型 |
| ------------ | -------- |
| 整型         | int      |
| 短整型       | short    |
| 长整型       | long     |
| 字符         | char     |
| 浮点型       | float    |
| 双精度浮点型 | double   |
| 无类型       | void     |

对于整型类 存在一个 `signed` 和 `unsigned` 也就是是否有符号的问题 默认是有符号`signed`

`void` 是一个 无数据类型 一般用于 *定义函数返回 、纯指针* 、 不接受参数

```c
#include <stdio.h>
int num = 10;
void func1(void ){ //没有返回值 并且不接受参数（可以省略）
    void* ptr;
    ptr = &num; //纯指针
	printf("1,23");
}
```

# 字符和字符串

```c
char str = '1'; //字符是 只存储一个字符
char* name = '1asd';
```

在C语言中 字符串默认按照` \0`结尾 （编译器自动添加）

# 运算符

最基本的 `+` `-` 这些都不说了

`++` 如果 `++a` 那么就是先加后用 如果是`a++` 那么就是  先用后加

下面是比较运算内容

![image-20260217230212884](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260217230212884.png)

位运算 这个需要好好说  逆向分析过程中都容易遇见

| 符号 | 作用                             |
| ---- | -------------------------------- |
| `&`  | 作为 `And` 全1则1                |
| `|`  | 作为`Or` 有1则1                  |
| `^`  | 异或 也就是如果相同 则0 不同则1  |
| `~`  | 取反                             |
| `<<` | 左移操作 转化为二进制后 左移一位 |
| `>>` | 右移操作 转化为二进制后 右移一位 |

三目运算符 声明如下

```
条件 ? 条件成立后 : 条件不成立
```

# 数组

存储相同数据类型的 空间连续的数据结构

```c
int num[10] //定义10个int类型的数组
double num[20]
char num[10]
```

对于数组初始化 有下面的方法

```c
int arr[3] = {0, 1, 2}; //所有元素初始化

int arr[5] = {-1, 1} // 其他元素默认设置为0

int arr[] = {0, 1, 3} // 不指定数组长度 自动推断
```

访问就是通过数组下标（从0开始）访问

# 分支

有 三种分支内容

if类型

```c
if(){

}else if(){

}
else{

}
```

switch 类型

```c
int num = 1;
switch(num){
	case 1:
		...
		break;
	case 2:
		...
		break;
	default:
		...
		break;
}
```

最后就是三目运算符

```c
int a=5, b=10;
int max = (a>b) ? 1 : 0; // 如果大于则返回1 否则0
```

# 循环

也是三个

```c
for(初始化,条件,更新){
}
```

```c
while(条件){
 //条件真循环
}
```

```c
do {
 //至少先执行一次
}while(条件)
```

# 结构体

是用户通过 基本数据类型 定义的一个自己的数据类型 这里还*不涉及类* 在C++才会说类的内容

```
struct 结构体名字{
	基本数据类型
}
```

```c
struct Student{
	int num;
	char name[50];
}
```

对于结构体的初始化可以通过下面方法进行

```c
struct Student st1;
struct Student st2 = {1,"Alice"};
```

对于内容的访问

```c
struct Student st2 = {1,"Alice"};
st2.num = 2;
strcpy(st2.name,"Bob"); //通过字符串拷贝
```

# 联合体

Union 允许一个地址空间 存储不同类型的数据 联合体的所有成员 共享空间 大小为最大的成员大小

```c
union Data{
	int i; // 4字节
	float b; // 4字节
	short c; // 2字节
	char d; // 1字节
}
```

也就是说 只需要4字节 就可以存储这个 `Data` 结构体是连续声明全部变量

如果 `sizeof(Data) `那么一定返回 4

```c
struct ip_addr{
 union{
 	struct{UCHAR s_b1,s_b2,s_b3,s_b4;} S_un_b; //unsigned的char
 	struct{USHORT s_w1,s_w2;} S_un_w; //unsigned的short
 	ULONG S_addr; ////unsigned的Long 32位4字节
 }S_un;
}
```

这个结构体占用最大4字节 为什么要这样定义

我们对IP访问的时候 可以直接访问 `S_addr` 获得一整个`IP地址` 也可以通过`s_w1/2 ` 获取IP的2字节内容 再者可以通过 `s_b1/2/3/4` 获得 1字节内容

这样就对取值很灵活 并且节省了空间

# 指针

一个变量 里面存储的内容 是另一个变量的地址

```c
int* ptr;
```

定义了一个 指向`int`数据的 一个指针

那么我们希望取我们定义好变量的内容给指针 就需要通过取地址符号

```c
int a = 10;
int* ptr = &a; //把a的地址给ptr
printf("%p",*ptr) // 这里输出的就是 a的地址通过16进制
```

如果我们希望获得指针 里面地址的数据 那么就通过 解析符号即可

```c
int a = 10;
int* ptr = &a; //把a的地址给ptr
printf("%d",*ptr) // 这里输出的就是 10
```

我们可以通过 指针运算 快速访问数组

```c
int arr[] = {0,1,2,3,4};
int* arr_ptr = &arr;  //这里指向的是 arr[0]
arr_ptr++; // 修改为指向 arr[1]
```

对于指针运算 默认增加的是指向内容的数据大小

函数指针

```c
int add(int a,int b){
	return a+b;
}
int (*func_ptr)(int,int) = add;
int result = func_ptr(1,2);
```

对于C语言 有一些注意的内容 `野指针` `空指针` `悬空指针`

```c
int* ptr;
*ptr = 10
```

上述内容就是一个 野指针  没有对指针进行初始化

```c
int* ptr = NULL;
```

如果对指针赋值为 NULL 直接导致程序崩溃 

```c
int* ptr = (int*)malloc(sizeof(int));
free(ptr); //申请 堆空间后 释放空间 但是没有对指针进行操作
```

如果后面通过` ptr` 使用 那么就会出现问题

# 动态内存分配

```c
#include <stdlib.h>
void* malloc(sizt_t size);//分配单个
void* calloc(sizt_t num,sizt_t size); //分配多个
void* realloc(void* ptr,sizt_t new_size) //对于地址重新分配
```

释放内存 这里就是C语言需要即使释放的内容

```c
void free(void* ptr)
```

C没有存在垃圾回收机制

# `typedef`

对已经存在的数据类型 构建新的名字

其实无论是 其他项目都会构建自己名字的数据类型 转化到最后 本质上都是基本数据类型的别名

```c
typedef int My_int;

My_int a; //本质上就是 int
```

有这个定义方法 我们可以对结构体继续优化

```c
typedef struct {
	int a;
	int b;
}my_data; //对这个结构体 起名字叫做 my_data
my_data m; //快速定义
```

# 内存层面了解C

![image-20260217235122498](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260217235122498.png)

C语言不可能 这么简单的 下面是一个真正的内存

![image-20260217235200877](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260217235200877.png)

1. 内核空间 是不可能访问的 32位进程 不可能出现 8开头 最多只能是7
2. exe就是PE内容
3. 局部变量保存在 栈中 
4. 全局和`static`声明的保存在 PE文件中 
5. 动态分配的保存 堆中