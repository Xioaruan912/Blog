## 代码

```c
#include <stdio.h>
void main() {
	int a = 10;
	int b = 11;
	switch (a+b){
	case 21:
		printf("21!\n");
		break;
	case 11:
		printf("11\n");
		break;
	default:
		break;
	}
}
```

这里提出一个新的知识点

**`break` 退出当前分支 是退出整体 switch 分支**

如果**没有`break`** 那么进入分支后就**一直执行** 并且**不再判断**

`default` 是如果所有case都没有 那么就执行 `default`

开始动态调试	

### 注意事项  

```
1. switch 里面值必须不能是浮点数
2. case 里面的不能一样
3. case 里面的值必须是常量 而不是变量
```

## 反调试

主要看`switch` 

```
	switch (a+b){
00941873  mov         eax,dword ptr [a]  
00941876  add         eax,dword ptr [b]  
00941879  mov         dword ptr [ebp-0DCh],eax  
0094187F  cmp         dword ptr [ebp-0DCh],0Bh  
00941886  je          __$EncStackInitStart+56h (09418A2h)  
00941888  cmp         dword ptr [ebp-0DCh],15h  
0094188F  je          __$EncStackInitStart+47h (0941893h)  
00941891  jmp         __$EncStackInitStart+63h (09418AFh)  
	case 21:
		printf("21!\n");
00941893  push        offset string "21!\n" (0947BD4h)  
00941898  call        _printf (09410CDh)  
0094189D  add         esp,4  
		break;
009418A0  jmp         __$EncStackInitStart+63h (09418AFh)  
	case 11:
		printf("11\n");
009418A2  push        offset string "11" (0947B34h)  
009418A7  call        _printf (09410CDh)  
009418AC  add         esp,4  
		break;
	default:
		break;
	}
```

首先计算表达式

```
00941873  mov         eax,dword ptr [a]  
00941876  add         eax,dword ptr [b]  
```

结果存储在`eax` 里面

```
00941879  mov         dword ptr [ebp-0DCh],eax  
0094187F  cmp         dword ptr [ebp-0DCh],0Bh 
```

首先进入第一个比较 和21 比较 `0B` = `11` 

如果正确 那么跳转到第二个分支 如果错误 顺序执行

```c
00941879  mov         dword ptr [ebp-0DCh],eax  
0094187F  cmp         dword ptr [ebp-0DCh],0Bh  //如果正确 进入je
00941886  je          __$EncStackInitStart+56h (09418A2h)  
00941888  cmp         dword ptr [ebp-0DCh],15h   //如果正确 进入je
0094188F  je          __$EncStackInitStart+47h (0941893h)  
00941891  jmp         __$EncStackInitStart+63h (09418AFh)//进入default
```

后面就是三个调用`printf` 函数 就不多说了

## 合并写法

```c
#include <stdio.h>
void main() {
	int a = 0;
	int b = 11;
	switch (a+b){
	case 21:case 11:   //关键写法
		printf("21! or 11 !\n");
		break;
	default:
		break;
	}
}
```

反汇编可以看见 也是一样比较 只是 `je` 执行的是一样的内容

```
00EB187F  cmp         dword ptr [ebp-0DCh],0Bh  
00EB1886  je          __$EncStackInitStart+47h (0EB1893h)  
00EB1888  cmp         dword ptr [ebp-0DCh],15h  
00EB188F  je          __$EncStackInitStart+47h (0EB1893h) 
```

# 为什么高效

如果可以用`switch`  那么就不要用`ifelse` 语句 

性能和可读性都很好

 这里就是高效的原因 全部在前面进行比较 比较完执行

```
00941879  mov         dword ptr [ebp-0DCh],eax  
0094187F  cmp         dword ptr [ebp-0DCh],0Bh  //如果正确 进入je
00941886  je          __$EncStackInitStart+56h (09418A2h)  
00941888  cmp         dword ptr [ebp-0DCh],15h   //如果正确 进入je
0094188F  je          __$EncStackInitStart+47h (0941893h)  
00941891  jmp         __$EncStackInitStart+63h (09418AFh)//进入default
```

但是这里的条件太少了 还是没有体现出 如果我们添加4-5个呢

```c
	switch (a+b){
00BF5273  mov         eax,dword ptr [a]  
00BF5276  add         eax,dword ptr [b]  
00BF5279  mov         dword ptr [ebp-0DCh],eax  //11
00BF527F  mov         ecx,dword ptr [ebp-0DCh]  //存入ecx
00BF5285  sub         ecx,1   //ecx -1 
00BF5288  mov         dword ptr [ebp-0DCh],ecx  
00BF528E  cmp         dword ptr [ebp-0DCh],14h  
00BF5295  ja          $LN7+0Dh (0BF52E5h)  
00BF5297  mov         edx,dword ptr [ebp-0DCh]  
00BF529D  movzx       eax,byte ptr [edx+0BF5310h]  
00BF52A4  jmp         dword ptr [eax*4+0BF52FCh]  
	case 21:
		printf("21! !\n");
```

可以发现 刚刚的 `cmp` `je` `jmp` 不一样了

```c
00BF5285  sub         ecx,1   //ecx -1 
00BF5288  mov         dword ptr [ebp-0DCh],ecx  
00BF528E  cmp         dword ptr [ebp-0DCh],14h  
00BF5295  ja          $LN7+0Dh (0BF52E5h)  
```

这里首先系统获取我们这里常量的最大值 如果 -1 还大于最大值 那么就直接跳转到 `dafeult` 这就是巧妙的地方

```
00BF5297  mov         edx,dword ptr [ebp-0DCh]  
00BF529D  movzx       eax,byte ptr [edx+0BF5310h]  
00BF52A4  jmp         dword ptr [eax*4+0BF52FCh]  
```

通过这个计算 就一定可以跳转到我们需要的地方

这里是通过查表的方法实现

![image-20250303122723456](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250303122723456.png)

这里是我去访问内存 然后比对出来的 可以发现 编译器将这些地址存入内存 然后通过首次比对 查看是否去 `default` 如果不去 然后进行查表

现在我们聚焦于

```
00BF5285  sub         ecx,1 
```

为什么可以通过这个然后比对算法 我们将数添加

```c
#include <stdio.h>
void main() {
	int a = 0;
	int b = 11;
	switch (a+b){
	case 100:
		printf("21! !\n");
		break;
	case 105:
		printf("11 !\n");
		break;
	case 400:
		printf("10 !\n");
		break;
	case 500:
		printf("1 !\n");
		break;
	default:
		break;
	}
}
```

目前最小值是100

![image-20250303123241341](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250303123241341.png)

可以发现 这个算法就是通过 减去最小值 100 然后比对

![image-20250303123309856](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250303123309856.png)

`50 = 最大值(150) - 最小值(100)`

如果比50还大 那么就说明没有`case` 到的 直接进入 `default`

否则进入查表

```
00685297  mov         edx,dword ptr [ebp-0DCh]  
0068529D  movzx       eax,byte ptr [edx+685310h]  
006852A4  jmp         dword ptr [eax*4+6852FCh]  
```

