# inline Hook实战 - 自己写的函数

首先写一个基本的 函数

```c++
#include <stdio.h>

int normal() {
	printf("Hello Normal");
	return 0;
}



int main() {
	normal();
	return 0;
}
```

ok 下面我们了解一下 `jmp` 的指令

我们随便写个 `for` 然后`jmp`看看

![image-20260206234305328](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260206234305328.png)

最基本的 inline hook使用 5 字节近跳 `E9 rel32`

```
e9 xx xx xx xx
```

**下一条指令地址** = 当前这条 `E9` 的地址 + 5

也就是近跳执行完本`JMP`指令后 相对地址  `指令地址 = EIP + 相对地址`

所以我们通过下面代码 去`hook`

```C++
#include <stdio.h>
#include <Windows.h>
int normal() {
	printf("Hello Normal\n");
	return 0;
}

void hook() {
	printf("Hook!!!!!!\n");
}


void install_hook() {
	unsigned char jmp_code[10] = { 0 };
	jmp_code[0] = 0xE9; //JMP的汇编
	int addr = (int)hook - ((int)normal + 5);  //当前EIP的值 +5 后被hook减去 这里5是JMP指令
	*(int*)&jmp_code[1] = addr;

	//normal 地址区域 可读可执行不可写 所以我们需要修改权限 这里是win32API
	DWORD oldProtect = 0;
	VirtualProtect(normal, 4096, PAGE_EXECUTE_READWRITE, &oldProtect);
	memcpy(normal, jmp_code,5);

}

int main(){
	install_hook();
	normal();
	return 0;
}
```

我们分析一下执行过程

# inline Hook实战 - 系统函数

我们可以写一个 win32的系统过程 

```c++
#include <Windows.h>


int main() {
	MessageBox(NULL, TEXT("你好呀"), TEXT("这是标题"), MB_OK);
	return 0;
}
```

我们这里是需要hook 系统的API 所以我们需要重写 构造

```c++
#include <Windows.h>
#include <stdio.h>

//重写一个自己的 MessageBox
int
WINAPI
MyMessageBox(
	_In_opt_ HWND hWnd,
	_In_opt_ LPCWSTR lpText,
	_In_opt_ LPCWSTR lpCaption,
	_In_ UINT uType)
{
	printf("这里是Hook后的MessageBox");
	return 0;
}
//写安装函数
void install() {
	unsigned char jmp_code[10] = { 0 };
	jmp_code[0] = 0xE9;
	int addr = int(MyMessageBox) - ((int)MessageBox + 5);
	*(int*)&jmp_code[1] = addr;
	DWORD lp = 0;
	VirtualProtect(MessageBox, 4096, PAGE_EXECUTE_READWRITE, &lp);
	memcpy(MessageBox, jmp_code, 5);
}


int main() {
	install();
	MessageBox(NULL, TEXT("你好呀"), TEXT("这是标题"), MB_OK);
	return 0;
}
```

这里就出现问题了 我们修改了 原本函数的执行过程 所以原本函数无法继续执行 那么这不是我们希望的 我们有的时候 只是希望监控函数

这里我们就需要写一个 C语言 去专门处理备份问题 并且也要考虑 我们HOOK走多少条汇编 我们就需要备份多少指令 下图是一个 备份和恢复执行的思考过程

![image-20260207002706383](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260207002706383.png)

也就是我们执行完 hook指令后 需要 继续执行 `MessageBox` 的指令 并且跳转到 原函数入口的下一条执行