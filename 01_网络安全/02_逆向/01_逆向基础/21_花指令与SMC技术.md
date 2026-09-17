我们之前学习了 反调试技术

存在静态和动态的两个方法 并且静态 存在 花指令 和 混淆等 

这里学一个最简单的两个混淆

# 花指令

## 基本原理

那么我们首先先要了解 反汇编是如何进行的

1. 线性扫描 通过一个一个解析处理 时间处理长 并且不可以很好处理 数据和指令
2. 递归行进算法 这个会在分析过程中 理解程序运行

![image-20260210122457875](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260210122457875.png)

那么其实对抗反汇编方法 也就很清晰明了了 人为参杂 混淆进入即可

这里给出一个简单的花指令

```c++
#include <stdio.h>

_declspec(naked)// 这里是声明这个函数不要增加任何 编译器辅助汇编
void test() {
	__asm {
		xor eax,eax
		mov eax,1
		jmp label1
		__emit 0xe9 //这里是插入立即数 0xe9 如果是线性扫描 那么会分析这个是一个 jmp

label1:
		mov ebx,1
		add eax,ebx
		ret
	}
}


int main() {
	test();
	printf("花指令");
	return 0;

}
```

![image-20260210123132707](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260210123132707.png)

可以发现 VC2019 分析代码的过程 也就是线性分析 导致后续内容 全部错误 这个情况使用 IDA就可以轻松识别

但是绕过IDA检测也是很简单的

```c++
#include <stdio.h>

_declspec(naked)// 这里是声明这个函数不要增加任何 编译器辅助汇编
void test() {
	__asm {
		xor eax,eax
		mov eax,1
		jz label1 //
		jnz label1 //如果修改了 无论如何都会跳转
		__emit 0xe9 

label1:
		mov ebx,1
		add eax,ebx
		ret
	}
}


int main() {
	test();
	printf("花指令");
	return 0;

}
```

![image-20260210123356264](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260210123356264.png)

IDA是通过控制分析算法 通过跳转 再重新对跳转进行线性 分析  那么遇见` jz `和` jnz `就需要分析两个跳转情况

对`jnz` 要跳转和不跳转 都需要分析 那么就会进入我们的立即数 导致线性分析算法 失效

CPU执行的时候 是永远不可能到达错乱的地方的

这就是混淆 花指令的 基本原理

# 如何复原

## 手动复原

如果我们分析 确定了 是花指令 那么我们对 目标选择 `undefine`

![image-20260210124117142](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260210124117142.png)

然后来到正确的地址 通过 `code` 解析

![image-20260210124148191](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260210124148191.png)

但是这个还是很麻烦的 如果有嵌套 又有 大量 这个明显不现实

我们可以编写程序 自动去除 把垃圾数据 直接填充为` nop` `0x90`

# SMC技术

代码自修改技术 在代码执行前 先修改

这也是加壳技术的基础

![image-20260210124514080](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260210124514080.png)

程序在静态分析过程中 是加密的 只可以看见一个 解密程序

在运行过程中 初始化代码执行 解密代码 从而实现 加壳

我们来看看关键函数

```c++
void test_smc() {
	PVOID codePage = VirtualAlloc(NULL, 4096, MEM_RESERVE | MEM_COMMIT, PAGE_EXECUTE_READWRITE);
	if (codePage) {
		ZeroMemory(codePage, 4096);
		memcpy(codePage, g_code, sizeof(g_code));
		decrypt_fun(codePage); //解密
		__asm {
			call codePage
		}
	}
}
```

这里加密解密都是很简单的 在使用 vs2019的时候 需要设置下面的内容

#### 更改项目设置（最推荐）

1. 打开 **项目属性**。

3. 找到 **启用增量链接 **，将其设置为 **否**。

   

![image-20260210140529744](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260210140529744.png)

```c++
#include <stdio.h>
#include <windows.h>

__declspec(naked)
void important_fun() {
	__asm {

		mov eax, 0x75b30ad0
		push 0
		push 0x92929292
		push 0x92929292
		mov ebx, esp

		push 0
		push ebx
		push ebx
		push 0
		call eax
		add esp, 0x0C

		ret
	}
}


void encrypt_fun() {
	unsigned char encryped_code[32] = { 0 };
	unsigned char* ptr = (unsigned char*)important_fun;
	for (int i = 0; i < 31; i++) {
		encryped_code[i] = ptr[i] ^ 0x11;
		printf("0x%02X, ", encryped_code[i]);
		if ((i + 1) % 8 == 0) {
			printf("\n");
		}
	}

	printf("\n================下面是加密前的函数======================\n");

	for (int i = 0; i < 31; i++) {
		printf("0x%02X, ", ptr[i]);
		if ((i + 1) % 8 == 0) {
			printf("\n");
		}
	}
}



int main()
{
	MessageBoxA(NULL, "start", "start", MB_OK);
	encrypt_fun();

	return 0;
}


```

这是SMC 加密过程 加密结果会得到一个 加密混淆的 十六进制

```
0xA9, 0xC1, 0x1B, 0xA2, 0x64, 0x7B, 0x11, 0x79,
0x83, 0x83, 0x83, 0x83, 0x79, 0x83, 0x83, 0x83,
0x83, 0x9A, 0xCD, 0x7B, 0x11, 0x42, 0x42, 0x7B,
0x11, 0xEE, 0xC1, 0x92, 0xD5, 0x1D, 0xD2,
================下面是加密前的函数======================
0xB8, 0xD0, 0x0A, 0xB3, 0x75, 0x6A, 0x00, 0x68,
0x92, 0x92, 0x92, 0x92, 0x68, 0x92, 0x92, 0x92,
0x92, 0x8B, 0xDC, 0x6A, 0x00, 0x53, 0x53, 0x6A,
0x00, 0xFF, 0xD0, 0x83, 0xC4, 0x0C, 0xC3,
```

下面是解密过程

```c++
#include <stdio.h>
#include <windows.h>


void decrypt_fun(PVOID address) {
	unsigned char* ptr = (unsigned char*)address;
	for (int i = 0; i < 31; i++) {
		ptr[i] = ptr[i] ^ 0x11;
		printf("0x%02X, ", ptr[i]);
		if ((i + 1) % 8 == 0) {
			printf("\n");
		}
	}
}

//写入混淆过后的内容
unsigned char g_code[] = {
	0xA9, 0xC1, 0x1B, 0xA2, 0x64, 0x7B, 0x11, 0x79,
	0x68, 0x64, 0x70, 0x7F, 0x79, 0x69, 0x64, 0x70,
	0x7F, 0x9A, 0xCD, 0x7B, 0x11, 0x42, 0x42, 0x7B,
	0x11, 0xEE, 0xC1, 0x92, 0xD5, 0x1D, 0xD2
};

//关键函数
void smc_test() {

	PVOID codePage = VirtualAlloc(NULL, 4096, MEM_RESERVE | MEM_COMMIT, PAGE_EXECUTE_READWRITE);
	if (codePage) {
		ZeroMemory(codePage, 4096);
		memcpy(codePage, g_code, sizeof(g_code));
		decrypt_fun(codePage);

		__asm {
			call codePage // 通过call 调用解密后的函数

		}
	}
}

int main()
{
	MessageBoxA(NULL, "start", "start", MB_OK);

	smc_test();
	return 0;
}

```



