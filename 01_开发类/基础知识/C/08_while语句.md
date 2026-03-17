## GOTO 方式

```C
#include <stdio.h>

int main() {
	int a = 0;
B:	printf("%d\n", a);
	a++;
	if (a < 10) {
		goto B;
	}
	
}
```

类似于汇编语言里面的`jump` 指令  主要汇编如下

```c
B:	printf("%d\n", a);
001F526C  mov         eax,dword ptr [a]  
001F526F  push        eax  
001F5270  push        offset string "%d\n" (01F7BD4h)  
001F5275  call        _printf (01F10CDh)  
001F527A  add         esp,8  //函数调用和堆栈平衡
	a++;
001F527D  mov         eax,dword ptr [a]  
001F5280  add         eax,1  
001F5283  mov         dword ptr [a],eax   // a++
	if (a < 10) {
001F5286  cmp         dword ptr [a],0Ah  
001F528A  jge         B+22h (01F528Eh)  
		goto B;
001F528C  jmp         B (01F526Ch)   //无条件跳转
	}
```

高级语言使用`while`

## while

```c
#include <stdio.h>

int main() {
	int a = 0;
	while (a < 10)
	{
		printf("%d\n", a);
		a++;
	}
}
```

```c
	int a = 0;
00135265  mov         dword ptr [a],0  
	while (a < 10)
0013526C  cmp         dword ptr [a],0Ah  //和10比较
00135270  jge         __$EncStackInitStart+42h (013528Eh)  //跳过循环
	{
		printf("%d\n", a);
00135272  mov         eax,dword ptr [a]  
00135275  push        eax  
00135276  push        offset string "%d\n" (0137BD4h)  
0013527B  call        _printf (01310CDh)  
00135280  add         esp,8  
		a++;
00135283  mov         eax,dword ptr [a]  
00135286  add         eax,1  
00135289  mov         dword ptr [a],eax  
	}
0013528C  jmp         __$EncStackInitStart+20h (013526Ch)//调到和10比较
}
0013528E  xor         eax,eax  
```

## break

```
跳出离break最近的 while 或者 switch 语句
```

```c
#include <stdio.h>

int main() {
	int j = 10;
	int a = 0;
	while (j--)
	{
		while (a % 2 == 0)
		{
			printf("这里是a:%d\n", a);
			break;
			a++;
		}
		printf("这里是j:%d\n", j);
	}

}
```

```
这里是a:0
这里是j:9
这里是a:0
这里是j:8
这里是a:0
这里是j:7
这里是a:0
这里是j:6
这里是a:0
这里是j:5
这里是a:0
这里是j:4
这里是a:0
这里是j:3
这里是a:0
这里是j:2
这里是a:0
这里是j:1
这里是a:0
这里是j:0
```

我们注意这里

```
break;
printf("这里是a:%d\n", a);
a++;
```

首先 `break` 就直接跳出了 所以后面的 `a++` 不会执行 我们可以发现 a每次都是`0` 没有进入该循环

只要执行到`break` 那么里面那个`while (a % 2 == 0)`的 就执行结束了

**所以 `break` 是直接结束一整个该循环**

## continue

打印奇数

```c
#include <stdio.h>

int main() {
	int j = 0;
	while (j < 10)
	{
		j++;
		if (j % 2 == 0) {
			continue;
		}
		printf("%d\n", j);

	}

}	
```

**`continue` 是跳出离他最近的 `while`、`switch` 一次循环**

意思就是他不会直接结束循环 而是停止**这一次**的循环

## do_while

```
do{

}while(表达式)
```

这样的话 即使表达式不成立 那么也会执行一次

```C
#include <stdio.h>

int main() {
	int j = 0;
	do {
		printf("%d", j);
	} while (j != 0);  //原本应该是当j != 0 的时候执行 
} 
```

此时输出一个`0` 说明 即使`while` 表达式不成立 那么也会执行一次

## For

首先我们可以知道执行顺序

```
for(表达式1;表达式2;表达式3){
	表达式4
}
```

执行顺序为 1 -> 2 -> 4 -> 3 并且**表达式2 一定要是 0 或者 非0**

举例子说明

```c
#include <stdio.h>

void T1() {
	printf("T1\n");
}

int T2() {
	printf("T2\n");
	return -1;
}

void T3() {
	printf("T3\n");
}


int main() {
	for (T1(); T2(); T3()) {
		printf("T4\n");
	}
} 
```

```
T1 T2 T4 T3
T2 T4 T3
T2 T4 T3
```

执行3次的结果如上 验证了顺序问题