远程线程注入的麻烦 就是`shellcode`的编写

所以我们需要一个C++编写的程序 实现注入 这就需要DLL注入 这样我们就不需要跟踪` Messagebox`等系统API了

# 远程线程注入DLL

我们上次说过 我们无论调用`CreateThread` 还是 `CreateRemoteThread`都是通过

```
DWORD WINAPI ThreadProc(LPVOID lpParameter);
```

这里过程方法如下

1. 通过 `VirtualAllocEx` 构建远程注入内存
2. 通过 `WriteProcessMemory` 把`dll` 路径写入远程内存中
3. 通过`CreateRemoteThread` 执行 `loadLibrary` 从而加载DLL

# 编写 DLL

我们现在需要一个 `DLL`为我们使用 

我们重新构建一个项目

![image-20260210104145090](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260210104145090.png)

```c
// dllmain.cpp : 定义 DLL 应用程序的入口点。
#include "pch.h"
#include <Windows.h>
BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
        MessageBox(NULL, TEXT("你好呀 DLL注入咯"), TEXT("DLL注入!!"), MB_OK);
        break;
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}
```

这样我们就得到一个 自己编写的DLL

现在尝试远程线程注入

主要修改地方如下：

```c++
	DWORD WriteBytes = 0;
	const char* dllPath = "C:\\Users\\USER\\Desktop\\win32\\Project1\\Dll1.dll";
	WriteProcessMemory(
		pi.hProcess,
		pRomoteMEM,
		dllPath,
		strlen(dllPath)+1,
		&WriteBytes
	);
```

但是我们需要执行的函数 是` loadLibrary `函数地址 是需要被计算的

```c++
LPVOID GetFunctionAddress(DWORD processId, const char* dllName, const char* funName) {

	HMODULE hMod = GetModuleHandleA(dllName);
	LPVOID funAddress = GetProcAddress(hMod, funName);

	DWORD offset = (DWORD)funAddress - (DWORD)hMod;

	// 增加 TH32CS_SNAPMODULE32 标志
	HANDLE hProcSnap = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE | TH32CS_SNAPMODULE32, processId);
	if (hProcSnap == INVALID_HANDLE_VALUE) {
		printf("快照失败，错误代码: %d\n", GetLastError());
		return NULL;
	}
	MODULEENTRY32 me32;
	me32.dwSize = sizeof(MODULEENTRY32);
	BOOL flag = Module32First(hProcSnap, &me32);
	while (flag)
	{
		if (!_stricmp(me32.szModule, dllName))
		{
			return (LPVOID)((ULONG_PTR)me32.modBaseAddr + offset);
		}
		flag = Module32Next(hProcSnap, &me32);
	}
	CloseHandle(hProcSnap);

	return NULL;
}
```

这里注意我们需要修改字符集为 默认

![image-20260210120325108](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260210120325108.png)

最后修改一下 注入内容

```c++
	// 写入DLL路径
	DWORD WriteBytes = 0;
	const char* dllPath = "C:\\Users\\12455\\Desktop\\win32\\Project1\\Dll1.dll";
	WriteProcessMemory(pi.hProcess,
		pRomoteMEM,
		dllPath,
		strlen(dllPath) + 1,
		&WriteBytes);


	//创建远程线程
	HANDLE romoteThread = CreateRemoteThread(
		pi.hProcess,
		NULL,
		0, 
		(LPTHREAD_START_ROUTINE)pfnLoadLibraryA, //输入执行的函数
		pRomoteMEM, //执行的参数
		NULL,
		NULL);
```

## 完整代码

```c++
#include <Windows.h>
#include <stdio.h>
#include <TlHelp32.h>

LPVOID GetFunctionAddress(DWORD processId, const char* dllName, const char* funName) {

	HMODULE hMod = GetModuleHandleA(dllName);
	LPVOID funAddress = GetProcAddress(hMod, funName);

	DWORD offset = (DWORD)funAddress - (DWORD)hMod;

	// 增加 TH32CS_SNAPMODULE32 标志
	HANDLE hProcSnap = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE | TH32CS_SNAPMODULE32, processId);
	if (hProcSnap == INVALID_HANDLE_VALUE) {
		printf("快照失败，错误代码: %d\n", GetLastError());
		return NULL;
	}
	MODULEENTRY32 me32;
	me32.dwSize = sizeof(MODULEENTRY32);
	BOOL flag = Module32First(hProcSnap, &me32);
	while (flag)
	{
		if (!_stricmp(me32.szModule, dllName))
		{
			return (LPVOID)((ULONG_PTR)me32.modBaseAddr + offset);
		}
		flag = Module32Next(hProcSnap, &me32);
	}
	CloseHandle(hProcSnap);

	return NULL;
}

int main() {

	//获取 进程ID 拿到目标函数句柄
	STARTUPINFO si = { sizeof(si) };
	PROCESS_INFORMATION pi; //这里保存句柄
	CreateProcess(TEXT("C:\\Windows\\SysWOW64\\notepad.exe"),
		NULL,
		NULL,
		NULL,
		FALSE,
		0,
		NULL,
		NULL,
		&si,
		&pi);

	WaitForInputIdle(pi.hProcess, 5000);
	LPVOID pfnLoadLibraryA = GetFunctionAddress(pi.dwProcessId, 
		"kernel32.dll", 
		"LoadLibraryA");


	// 申请内存
	LPVOID pRomoteMEM = VirtualAllocEx(
		pi.hProcess,
		NULL,
		100,
		MEM_RESERVE | MEM_COMMIT,
		PAGE_EXECUTE_READWRITE
	);

	// 写入DLL路径
	DWORD WriteBytes = 0;
	const char* dllPath = "C:\\Users\\12455\\Desktop\\win32\\Project1\\Dll1.dll";
	WriteProcessMemory(pi.hProcess,
		pRomoteMEM,
		dllPath,
		strlen(dllPath) + 1,
		&WriteBytes);


	//创建远程线程
	HANDLE romoteThread = CreateRemoteThread(
		pi.hProcess,
		NULL,
		0, 
		(LPTHREAD_START_ROUTINE)pfnLoadLibraryA,
		pRomoteMEM,
		NULL,
		NULL);


	WaitForSingleObject(romoteThread, INFINITE); // 等待远程线程的结束
	CloseHandle(romoteThread);
	return 0;
}
```

这样就实现了远程DLL注入

我们可以通过` Process Explorer`查看

![image-20260210120553083](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260210120553083.png)

## 弊端

这里如果细心 可以发现我增加了一个代码

```
WaitForInputIdle(pi.hProcess, 5000);
```

也就是 需要等待 `notepad `启动  当`nodepad`启动后 加载其他`DLL`才会被执行

如果我们需要 在启动过程就调用 `远程线程DLL `就有其局限性

如果我们需要抢在 目标程序执行前 抢占 关键函数 那么这个方法就是不可以的

# 导入表注入DLL

也就是双桥结构

我们可以把需要导入的信息 塞入 导入表中 这样 自己就会加载我们的`DLL`

1. 需要注入的程序读入内存 并且文件末尾增加一个节
2. 拷贝原本的 导入表 到新的节中
3. 在 新节的导入表中 增加一个 导入描述符
4. 增加 8字节 INT 8字节IAT
5. 存储注入DLL名字
6. 增加一个 _IMAGE_IMPORT_BY_NAME 并且存入函数名字到本结构体的第一个变量中
7. 把刚刚 _IMAGE_IMPORT_BY_NAME 赋值给INT和IAT的第一项
8. 把DLL所在的位置的首地址 RVA 给新增导入表的Name 
9. 修改数据目录 导入表的VirtualAddress和name

网络上有现成的代码

## 弊端

需要修改PE文件 但是许多PE都有数字签名 篡改PE会导致签名失效

如果还希望 实现抢在 目标程序执行前 抢占 关键函数

就可以通过注册表注入

![image-20260210121825482](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260210121825482.png)

第二个修改为1 第一个修改为自己的DLL 就可以实现注入 但是注意 这里没有办法注入到希望的程序中 有可能会注入到 系统程序中 导致电脑死机