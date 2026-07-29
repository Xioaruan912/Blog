使用static修饰的内容 就是一个全局变量 只不过是一个私有的全局变量

# 面向过程

面向过程就是 没有类的定义 每个执行都是通过函数 实现

如果我的函数的全局变量 希望只给我这个函数使用那么我们可以在函数内部定义 

此时 内部定义的变量是全局变量 并且是私有的

```c
#include <stdio.h>

void fun(int b) {
	static int a;
	a = b;
	printf("a = %d", a);
}

void main() {
	fun(1);
	return;
}
```

我们单步进入 `fun` 函数看看

```c
#include <stdio.h>

void fun(int b) {

	static int a;
	a = b;
00211791  mov         eax,dword ptr [b]  
00211794  mov         dword ptr [a (021A144h)],eax   //可以发现这里的 a 是一个全局变量地址
	printf("a = %d", a);
00211799  mov         eax,dword ptr [a (021A144h)]  
0021179E  push        eax  
0021179F  push        offset string "a = %d" (0217B30h)  
002117A4  call        _main (02110CDh)  
002117A9  add         esp,8   
}

```

# 面向过程

```c
#include <stdio.h>

class MyClass
{
private:
	int a;
	int b;
	static int z;
};
int MyClass::z = 0;   //全局变量 z初始化

void main() {
	return;
}
```

