我们在上一节里面可以发现反汇编存在一个指针 叫做 `THIS`

```
00AE179A  mov         eax,dword ptr [this]  
00AE179D  mov         eax,dword ptr [eax] 
```

我们可以通过反汇编查看 可以发现 `this指针` 就是结构体首地址的指针 通过`ecx`传递

```
00AE190B  lea         ecx,[S]  
00AE190E  call        Student::plus (0AE136Bh)  
```

这个`[s]` 就是`this`指针 是默认传递的 用不用都是存在的

## 使用this指针

```c++
#include <stdio.h>

struct Student
{
	int age;
	int high;
	int num;
	int c;

	void init(int age, int c) {   //通过this 指定结构体变量 然后传递值 是传递给成员变量 而不是 函数的局部变量的 防止混乱
		this->age = age;
		this->c = c;
	}
	void printfInit() {
		printf("%d --- %d", age, c);
	}
};



int main() {
	Student S;
	S.init(10000, 1);
	S.printfInit();
	getchar();
}
```

```c
		this->age = a;
00E019CA  mov         eax,dword ptr [this]  
00E019CD  mov         ecx,dword ptr [age]  
00E019D0  mov         dword ptr [eax],ecx  
		this->c = b;
00E019D2  mov         eax,dword ptr [this]  
00E019D5  mov         ecx,dword ptr [c]  
00E019D8  mov         dword ptr [eax+0Ch],ecx  
//可以发现通过 this指针 - eax 我们可以写入值
	}
```

不允许对this指针进行其他 ++ -- 操作 只是用于处理数据的