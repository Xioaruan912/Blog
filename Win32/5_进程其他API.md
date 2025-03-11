每次创建一个进程 必需要起码有一个线程 这是我们之前学习知道的

并且 通过`CreateProcess` 我们可以得到 `进程编号 线程编号 进程句柄 线程句柄`

 对于句柄 就是能够操作内核对象的唯一方法 是属于进程的唯一索引

# 进程ID和句柄

```c
#include <windows.h>
#include <stdio.h>

BOOL CreateChileProcess(LPCWSTR lpApplicationName,LPWSTR lpCommandLine) {
	STARTUPINFO si;
	ZeroMemory(&si, sizeof(si));
	PROCESS_INFORMATION pi;
	ZeroMemory(&pi, sizeof(pi));
	si.cb = sizeof(si);
	CreateProcessW(
		lpApplicationName,
		lpCommandLine,
		NULL,
		NULL,
		FALSE,
		0,
		NULL,
		NULL,
		&si,
		&pi
	);
	printf("PID:%x - 进程句柄:%x",pi.dwProcessId,pi.hProcess);
    getchar();
}

void main() {
	LPCWSTR lpApplicationName = L"C:\\Users\\Administrator\\AppData\\Local\\Google\\Chrome\\Application\\chrome.exe";
	LPWSTR  lpCommandLine = L"\"C:\\Users\\Administrator\\AppData\\Local\\Google\\Chrome\\Application\\chrome.exe\" https://baidu.com/";
	CreateChileProcess(lpApplicationName, lpCommandLine);
}
```

![image-20250311101459583](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250311101459583.png)

除了进程的句柄表  OS有自己的句柄表 叫做全局句柄表

包含所有正在运行 的进程和线程 所以只要去全局句柄表里差 其实都无法躲藏

```
PID 是 全局句柄表 全局有意义
进程句柄 是 私有句柄表的编号
```

我们进行测试 首先 将我们上面输出的内容打包成 exe 并且更改名字

![image-20250311103218451](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250311103218451.png)

[`openProcess`](https://learn.microsoft.com/zh-cn/windows/win32/api/processthreadsapi/nf-processthreadsapi-openprocess)

```
HANDLE OpenProcess(
  [in] DWORD dwDesiredAccess,   //需要什么权限
  [in] BOOL  bInheritHandle,    //是否允许子进程继承自己的表
  [in] DWORD dwProcessId		//PID
);
```

第一个参数权限

[`dwDesiredAccess`](https://learn.microsoft.com/zh-cn/windows/win32/procthread/process-security-and-access-rights)

```c
#include <windows.h>
#include <stdio.h>
void main() {
	HANDLE hProcess;
	hProcess = OpenProcess(PROCESS_ALL_ACCESS, FALSE, 0x8358);  //这个时候 0x8358 变为了本进程的句柄

	if (!TerminateProcess(hProcess, 1)) {
		printf("关闭进程失败");
	}
	getchar();
}
```

运行后 发现 Chrome 关闭了

## 挂起



现在继续了解`CreateProcess` 的成员

![image-20250311103536952](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250311103536952.png)

```
控制优先级类和创建进程的标志
```

这里是对于要打开进程的配置 包括使用新的控制台等等

我们主要关注

```
CREATE_SUSPENDED
0x00000004
新进程的主线程处于挂起状态创建，在调用 ResumeThread 函数之前不会运行。
```

如果我们使用挂起的方法 那需要调用后才会继续执行 这样的话就可以提前注入 其他程序的代码

```c
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>

BOOL CreateChildProcess(LPCWSTR lpApplicationName, LPWSTR lpCommandLine) {
	STARTUPINFO si;
	ZeroMemory(&si, sizeof(si));
	PROCESS_INFORMATION pi;
	ZeroMemory(&pi, sizeof(pi));
	si.cb = sizeof(si);
	if (!CreateProcessW(
		lpApplicationName,
		lpCommandLine,
		NULL,
		NULL,
		FALSE,
		CREATE_SUSPENDED,
		NULL,
		NULL,
		&si,
		&pi)) {
		printf("CreateProcess failed (%d).\n", GetLastError());
		return FALSE;
	}
	for (int i = 0; i <= 8; i++) {  //这里可以替换恶意程序
		Sleep(1000);
		printf("------------------\n");
	}
	ResumeThread(pi.hThread);
	CloseHandle(pi.hProcess);
	CloseHandle(pi.hThread);
}

void main() {
	LPCWSTR lpApplicationName = L"C:\\Users\\Administrator\\AppData\\Local\\Google\\Chrome\\Application\\chrome.exe";
	LPWSTR  lpCommandLine = L"\"C:\\Users\\Administrator\\AppData\\Local\\Google\\Chrome\\Application\\chrome.exe\" https://baidu.com/";
	CreateChildProcess(lpApplicationName, lpCommandLine);
}
```

最后一个成员

```
[in, optional] lpCurrentDirectory

进程的当前目录的完整路径。 该字符串还可以指定 UNC 路径。

如果此参数 NULL，则新进程将具有与调用进程相同的当前驱动器和目录。 （此功能主要用于需要启动应用程序的 shell，并指定其初始驱动器和工作目录。
```

我们可以指定工作目录 默认是 父进程的工作路径