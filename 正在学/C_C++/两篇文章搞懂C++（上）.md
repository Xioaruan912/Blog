概念很多 只需要记住 后续 实战编写的时候 只需要可以 反应出 有这个东西就可以了

`C++` 内容是比C还要更多的

本文只说明下面知识点

![image-20260218115909558](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260218115909558.png)

`C++`难点就是 语法过于多了 版本更替很快

![image-20260218120046412](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260218120046412.png)

但是一般 最多使用到 `C++14` 我们主要使用`C++11语法`学习完毕即可

# Hello World

我们来看看 `C++ `的基础编程

```c++
#include <iostream>

int main() {
	std::cout << "hello World" << std::endl;
	return 0;
}
```

可以发现  和`C语言` 不同了  C语言一般都是按照`.h`结尾

```
std::cout
```

前面的`std::` 是命名空间

也就是我要求访问的是` std`里面的` cout` 防止模块间函数冲突 

其中的`std` 是C++内置标准库的名字

`cout`和`endl` 是 **流对象** 这也就是面向对象编程的内容

`<<`是用于 位运算 但是 `std`的`cout` **重载**了这个符号  从大达到 符号包裹实现 字符串输入

这也有一个简单的方法

```c
#include <iostream>
using namespace std;

int main() {
	cout << "hello World" << endl;
	return 0;
}
```

我们这里直接声明 使用 `std`这个命名空间 可以发现就不需要写` std::cout` 但是如果这样 可能后续维护会比较困难 因为不知道用的是什么库

# 面向对象编程

OOP 也就是模拟现实的一个对象的特征 从而实现面向对象编程

# 类

是对象的抽象意思 包含 数据成员和成员函数

```c
#include <iostream>
using namespace std;

class Thread {
public:
	void run() {
		cout << "线程执行" << endl;
	}
private:
	unsigned int Thread_ID;
};
```

这里我们定义了一个函数 `run` 和一个成员变量`Thread_ID`

那么真正的对象 是我们需要去初始化它 下面有两个方法初始化 一个是静态声明 一个是动态分配

```c
Thread t;
t.run();
```

```c
Thread* t = new Thread();
t->run()
delete t;
```

可以发现下面那个需要手动删除

```c
#include <iostream>
using namespace std;

class Thread {
public:
	void run() {
		cout << "线程执行" << endl;
	}
private:
	unsigned int Thread_ID;
};


int main() {
	Thread* t = new Thread;
	t->run();
	delete t;
	return 0;
}
```

# 权限

上面有两个关键字 `private` 和 `public` 其实还有一个 `proctected`

主要就是 私有还是公开 、

如果 `private` 只允许在 写 类的时候 通过`成员函数`访问 并且只可以是自己访问 子类都不可以访问

如果 `public` 那么我们`Thread* t = new Thread;` 可以对 `t`的数据进行修改

如果`proctected` 那么只允许 自己类和 子类 访问

当然 我们逆向过程 其实无所谓的 这里不是内存不允许访问 而是过不去编译器这关 但是我们 动态分析的时候 可以访问

# 静态成员

我们知道 上面定义的内容 需要通过 类的 初始化 也就是变为 实例 才可以

```c
#include <iostream>
using namespace std;

class Thread {
public:
	void run() {
		cout << "线程执行" << endl;
	}
	static int function_name; //这里定义了 静态成员
private:
	unsigned int Thread_ID;
};


int Thread::function_name = 0; //必须初始化在全局的域中

int main() {
	Thread* t = new Thread;
	t->run();
	delete t;
	return 0;
}
```

这个静态变量 是跟着类的 也就是说 即使你初始化100个实例 `function_name` 在内存中 只有一个 并且`共享`给所有人

1. 需要初始化在全局中 
2. 并且最好通过 `Thread::function_name` 访问

# 静态成员函数

这个函数的特点就是 只允许访问 静态成员

```c
#include <iostream>
using namespace std;

class math {
public:
	int value;
	static double PI;
	static double add(double a, double b) {
		return a + b + PI;
	}
};

double math::PI = 3.1415926;

int main() {
	double res = math::add(1.1, 2.2); //可以发现我都没有 实例化
	cout << res << endl;
	return 0;
}
```

如果我们强行访问 就会报错

![image-20260219142923501](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260219142923501.png)



# 构造函数和析构函数

如果没有写构造函数 那么编译器会自己写一个 空构造函数

构造函数 是和 类的名字一样 没有返回值 但是可以有参数（重载） 构建对象的时候 自动调用

析构函数 类名字前加 `~` 没有返回类型 没有参数（不可以重载） 对象消亡的时候 自动调用

```c
#include <iostream>
using namespace std;

class Thread {
public:
	void Printf_ThreadID() {
		cout << Thread_ID << endl;
	}
	Thread() { cout << "Thread 被构造了" << endl; }
	~Thread() { cout << "Thread 结束了" << endl; }
private:
	unsigned int Thread_ID = 0;
};


int main() {
	Thread* t = new Thread(); //执行构造函数
	system("pause");
	delete(t); //执行析构函数
	system("pause");
	return 0;
}
```

如果我们希望 直接在 构造函数 对成员变量初始化 那么可以通过下面方法

```c
#include <iostream>
using namespace std;

class Thread {
public:
	void Printf_ThreadID() {
		cout << Thread_ID << endl;
	}
	Thread() { cout << "Thread 被构造了" << endl; }
	Thread(int i) : Thread_ID(i) { //后面初始化了 当前类的Thread_ID
		cout << "Thread 被构造了 当前ID:" << this->Thread_ID << endl;
	}
private:
	unsigned int Thread_ID = 0;
};


int main() {
	Thread* t = new Thread(100);
	delete(t);
	system("pause");
	return 0;
}
```

# 继承

封装性 其实就是上面面向对象编程的内容 这里说一下继承

也就是说我们可以写一个 最基本的 基本类 然后不断有新的 类继承 从而实现构建完整对象 那么继承的这个类我们叫做子类

子类 无法访问`private `权限

```c
#include <iostream>
using namespace std;

class Thread {
public:
	unsigned int Thread_ID = 0;
	void Printf_ThreadID() {
		cout << Thread_ID << endl;
	}

};

class WinThread :public Thread {
public:
	void stop() {
		cout << "stop"<< endl;
	}
};




int main() {
	WinThread t;
	t.Printf_ThreadID(); //可以发现可以访问基本类的函数
	t.stop();
	return 0;
}
```

![image-20260219143719704](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260219143719704.png)

## 继承权限

这里有一个 `class WinThread :public Thread` 这里的权限是什么呢 

这里是说明被继承的 权限 也就是`public `说明 我继承了`Thread` 并且保证 `Thread`的内容可以被外部调用 例如

```c
	WinThread t;
	t.Printf_ThreadID(); //可以发现可以访问基本类的函数
	return 0;
```

如果我们使用 `protected ` 那么继承过来的 内容 全部修改为 `protected`权限 只允许 子类内部调用 不允许外部调用

如果使用 `private` 继承 那么在 `WinThread` 可以访问 但是如果使用的是 孙子类 就不允许访问

```c
class WinThread : private Thread {};
class MyThread : public WinThread {}; //这里已经不允许 访问 Thread 的内容了
```

但是在` WinThread` 还是可以访问的

```c
#include <iostream>
using namespace std;

class Thread {
public:
	unsigned int Thread_ID = 0;
	void Printf_ThreadID() {
		cout << Thread_ID << endl;
	}

};

class WinThread :private Thread {
public:
	void stop() {
		Printf_ThreadID(); //访问
		cout << "stop"<< endl;
	}
};


int main() {
	WinThread t;
	t.stop();
	return 0;
}
```

# 重载

在我们学习构造函数的时候 其实可以定义多个 带有不同 参数个数的 构造函数 从而实现函数的重载

```c
#include <iostream>
using namespace std;

class Thread {
public:
	Thread() { cout << "Thread 被构造了" << endl; }
    
    //实现构造函数的重载
	Thread(int Thread_ID)  {
		this->Thread_ID = Thread_ID;
	}
	~Thread(){ cout << "Thread 要被消失了 当前的ID是" << Thread_ID << endl; }
private:
	unsigned int Thread_ID = 0;
};


int main() {
	Thread* t = new Thread(100);
	delete(t);
	system("pause");
	return 0;
}
```

当然不需要是在类中 在一个 作用域内 可以定义不同的`普通函数`  

`成员函数`也可以重载

```c
#include <iostream>
using namespace std;

void print() {
	cout << "print执行" << endl;
}
void print(int a) {
	cout << "print带参数的执行" << a << endl;
}
int main() {
	print();
	print(1);
	return 0;
}
```

需要注意 重载 要求 满足 下面条件之一

1. 参数 类型不同
2. 参数 个数不同

即使 返回值不同 不满足上面的一个 都不算重载

# 运算符重载

允许 对 类的内部 对运算符进行重载

```c
#include <iostream>
using namespace std;

class Thread {
public:
	void Printf_ThreadID() {
		cout << Thread_ID << endl;
	}
	Thread(int _Thread_ID) {
		Thread_ID = _Thread_ID;
	}
	//实现对加法的 重载 
	//这里是实现 如果对两个 Thread 执行加法 那么就变为 返回一个新类
	Thread operator+(const Thread& other_Thread) {
		return Thread(this->Thread_ID + other_Thread.Thread_ID);
	}
	void print() {
		cout << Thread_ID << endl;
	}
private:
	unsigned int Thread_ID = 0;
};


int main() {
	Thread t1(100);
	Thread t2(10001);
	Thread t3 = t1 + t2;
	t3.print();
	return 0;
}
```

这样我们就实现了 运算符 重载 从而实现 两个 实例的相加

# 仿函数

其实就是对 `()` 的重载

```c
#include <iostream>
using namespace std;

class myClass {
public:
	int operator()(int a,int b ) {
		return a + b;
	}
};


int main() {
	myClass m;
	int res = m(1, 10);
	cout << res << endl;
	return 0;
}
```

也就是看起来像函数一样 所以叫做仿函数

# this

非静态成员 默认都有一个 `this` 指针 用于 区别 不同名字

```c
#include <iostream>
using namespace std;

class Thread {
public:
	Thread(int Thread_ID)  {
        //这里就是区别了 不同 名字 一个是 传入的 一个是本类的
		this->Thread_ID = Thread_ID;
	}
private:
	unsigned int Thread_ID = 0;
};


int main() {
	Thread* t = new Thread(100);
	delete(t);
	return 0;
}
```

# 虚函数 动态多态性

```c
#include <iostream>
using namespace std;

class myClass {
public:
	void print() {
		cout << "执行" << endl;
	}
};


class WinmyClass : public myClass {
public:
	void print() {
		cout << "执行windows咯" << endl;
	}
};

class LinuxmyClass :public  myClass {
public:
	void print() {
		cout << "执行linux咯" << endl;
	}
};

int main() {
	myClass* m = new WinmyClass; //这里通过基类 指针 指向一个 继承后的类
	m->print();
	return 0;

}
```

上述代码 在执行 这里由于是 `myClass`的指针 所以他会去执行 `myClass`的`print` 

但是如果我们给 `myClass`的函数变为虚函数 那么就会执行 继承类的

```c
#include <iostream>
using namespace std;

class myClass {
public:
	virtual void print() {
		cout << "执行" << endl;
	}
};


class WinmyClass : public myClass {
public:
	void print() {
		cout << "执行windows咯" << endl;
	}
};

class LinuxmyClass :public  myClass {
public:
	void print() {
		cout << "执行linux咯" << endl;
	}
};

int main() {
	myClass* m = new WinmyClass; //这里通过基类 指针 指向一个 继承后的类
	m->print();
	return 0;

}
```

调用方法 实际上是子类的方法

这里是运行的时候 动态绑定 所以我们叫做 动态多态性

# 纯虚函数

上面我们可以 构建父类对象本身 从而实现 调用 基本类的 `print`

```c
#include <iostream>
using namespace std;

class myClass {
public:
	virtual void print() = 0; //纯虚函数
};


class WinmyClass : public myClass {
public:
	void print() {
		cout << "执行windows咯" << endl;
	}
};

class LinuxmyClass :public  myClass {
public:
	void print() {
		cout << "执行linux咯" << endl;
	}
};

int main() {
	myClass* m = new WinmyClass; //这里通过基类 指针 指向一个 继承后的类
	m->print();
	return 0;

}
```

这样就是说明 子类必须 重写虚函数

如果这个类 有纯虚函数 那么就是一个抽象类 不允许被实例化 不允许`new`

主要是用于接口使用 其他类必须实现这个 函数

# 引用

通过引用 可以防止 值拷贝 从而降低性能和内存占用

通过引用已经存在的 变量 从而修改内存中 唯一变量

```c
#include <iostream>
using namespace std;


int main() {
	int a = 100;
	int& b = a; //b引用了a

	b = 1000;
	
	cout << a << endl;
	cout << b << endl;

}
```

其实就是和指针一样  修改的话 是直接对 唯一变量修改

底层下 是 通过指针实现

![image-20260219153413140](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20260219153413140.png)