# IATHOOK原理

我们首先看看不同`call`方法

```C
#include <Windows.h>
#include <stdio.h>

void print_hello() {
	printf("hello World");
}


void main() {
	print_hello();
	MessageBox(NULL, TEXT("你好"), TEXT("你好呀！！！！"), MB_OKCANCEL);
}
```

我们去查看汇编

```
E8 E0 F9 FF FF       call        print_hello (02012C6h) 
...
FF 15 98 B0 20 00    call        dword ptr [__imp__MessageBoxW@16 (020B098h)]  
```

可以发现 一个是`地址call` 一个是`ptrcall `也就是`指针call`

我们可以看看这个地址`020B098h` 是在哪里

![image-20260208173318885](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260208173318885.png)

可以发现 是在我们编写的 PE 文件内部的

在PE数据目录中 保存着 导入表和导入地址表（IAT）

![image-20260208173446172](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260208173446172.png)

我们可以通过导入表 找到` IAT `和`INT`

`INT`是保存名字` IAT`保存地址 二者 一一对应 那么明显发现 通过修改 `IAT表`中的指针 那么我们就可以直接` HOOK`了

# IATHOOK实战

```C
#include <Windows.h>

int
WINAPI
HOOKMessageBoxW(
    _In_opt_ HWND hWnd,
    _In_opt_ LPCWSTR lpText,
    _In_opt_ LPCWSTR lpCaption,
    _In_ UINT uType) {
    MessageBoxA(NULL, "HOOK你好", "HOOK你好呀！！！！", MB_OKCANCEL);
    return 0;
}
void main() {
	MessageBoxW(NULL, TEXT("你好"), TEXT("你好呀！！！！"), MB_OKCANCEL);
}
```

这是通过W和A防止HOOK的循环

1. 定位到IAT表 【关键】
2. 安装HOOK 把HOOK函数地址写入IAT中

第一步就是

1. 定位到 导入表
2. 找到对应DLL的导入描述符
3. 通过INT表找到对应函数名字的下标 
4. 最后通过下标定位 导入地址表IAT的下标 取值就是指针了

 

```c
#include <Windows.h>
#include <stdio.h>

int
WINAPI
HOOKMessageBoxW(
    _In_opt_ HWND hWnd,
    _In_opt_ LPCWSTR lpText,
    _In_opt_ LPCWSTR lpCaption,
    _In_ UINT uType) {
    MessageBoxA(NULL, "HOOK你好", "HOOK你好呀！！！！", MB_OKCANCEL);
    return 0;
}

//双桥结构
bool install_HOOK(const char* dllName,const char* funName, void* HookAddress) {
    //获取当前 PE 的基地址
    HMODULE hModule = GetModuleHandle(NULL);
    //获取当前 DOS头 地址 DOS头 = PE基地址 
    PIMAGE_DOS_HEADER ptrDosHeader = (PIMAGE_DOS_HEADER)hModule;
    //获取当前 NT头 地址 NT头 = 基地址 + DOS头的 e_lfanew
    PIMAGE_NT_HEADERS32 ptrNtHeader = (PIMAGE_NT_HEADERS32)((DWORD)hModule + (DWORD)ptrDosHeader->e_lfanew);
    //获取当前 可选头 地址  可选头 = NT头->可选头
    PIMAGE_OPTIONAL_HEADER32 ptrOptionalHeader = &ptrNtHeader->OptionalHeader;\
    //获取 数据目录 中的导入表 
    IMAGE_DATA_DIRECTORY dataDirectory = ptrOptionalHeader->DataDirectory[1];
    //获取 导入描述符 这里的是一个偏移地址 所以我们需要加上基地址才可以
    PIMAGE_IMPORT_DESCRIPTOR importDescriptor = (PIMAGE_IMPORT_DESCRIPTOR)((DWORD)dataDirectory.VirtualAddress + (DWORD)hModule);
    //通过循环遍历获取当前PE文件的导入描述符
    while(importDescriptor->Name) {
        //导入描述符获取名字
        const char* IDName = (const char*)((DWORD)(hModule) + importDescriptor->Name);
        if (strcmp(dllName, IDName) == 0) {
            //匹配成功 找INT
            PIMAGE_THUNK_DATA pINT = (PIMAGE_THUNK_DATA)((DWORD)(hModule) + importDescriptor->OriginalFirstThunk);
            //找IAT
            PIMAGE_THUNK_DATA pIAT = (PIMAGE_THUNK_DATA)((DWORD)(hModule) + importDescriptor->FirstThunk);

            //循环查找INT 函数名字所在的下标
            while (pINT->u1.Function) {
                PIMAGE_IMPORT_BY_NAME pImageImportByName = (PIMAGE_IMPORT_BY_NAME)((DWORD)(hModule) +(DWORD)pINT->u1.Function);
                if (strcmp(pImageImportByName->Name, funName) == 0){
                    DWORD* targetFuncAddress = (DWORD*)pIAT;

                    //HOOK操作
                    DWORD lp = 0;
                    VirtualProtect(targetFuncAddress, 4096, PAGE_EXECUTE_READWRITE,&lp);
                    *targetFuncAddress = (DWORD)HookAddress;
                    VirtualProtect(targetFuncAddress, 4096, lp, &lp);
                    return true; 
                }
                //双桥同步移动
                pINT++;
                pIAT++;
            }
        }
        importDescriptor++;
    }
}



void main() {
    install_HOOK("USER32.dll", "MessageBoxW", HOOKMessageBoxW); //需要传入大写 否则通过 stricmp C++方法写
	MessageBoxW(NULL, TEXT("你好"), TEXT("你好呀！！！！"), MB_OKCANCEL);
}
```

这个方法好的内容是 我通过修改指针操作 所以我们可以 保存原函数 也就是 `MessageBoxW`的指针  通过我们HOOK的函数内部 调用即可