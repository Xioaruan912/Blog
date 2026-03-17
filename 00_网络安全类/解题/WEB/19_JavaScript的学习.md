# JavaScript的学习

[HTML的学习-CSDN博客](https://blog.csdn.net/m0_64180167/article/details/134569371?spm=1001.2014.3001.5501) 

从html的学习中 其实我已经用到了JavaScript的脚本 （GPT）

例如

```xml
echo '<script>alert("账号密码错误"); window.location="index.html";</script>';
```

弹窗 然后定位到 index.html

这里能够让我们更加快速执行一些操作

## JS 用法

```cobol
首先 JS代码 需要通过 <script></script>包裹
 
其次 可以写入在 head 和 body中
```

最简单的JS就是类似XSS的弹窗

```cobol
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JavaScript学习</title>
</head>
<body>
    <script>alert("这是一个简单的弹窗");</script>
    
</body>
</html>
```

### JS 写html信息

```xml
document.write("<h1>这是通过JS document输出的语句</h1>");
```

我们可以发现 通过document 可以加上html的标签 然后输出内容

然后我们可以通过id的指定 实现javascript的调用

```cobol
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script>
        function check(){
            var check123 = document.getElementById('check');
            if(check123.innerHTML === '这是一个js脚本'){
            check123.innerHTML='6666';
            }else{
            check123.innerHTML='这是一个js脚本';
        }
    }
    </script>
</head>
<body>
    <p id="check">这是一个js脚本</p>
    <button type="button" onclick="check()">点我一下咯</button>
</body>
</html>
```

发现 这个就很简单的写法 通过 getID 获取到目标地点 然后inner 替换成666

在下面的button时触发

这就是一个最简单的javascript脚本

外部引用的话就是下面这个例子



<img src="https://i-blog.csdnimg.cn/blog_migrate/503b9443848f7213f169476061d28a84.png" alt="" style="max-height:411px; box-sizing:content-box;" />


这样就实现了javascrip的运行

## 在浏览器中执行javascript

这里要学习在浏览器中执行

我们看看我们定义的是check函数

所以我们可以通过开发者工具打开控制台



<img src="https://i-blog.csdnimg.cn/blog_migrate/43ddb5e70dbf65ee5c59a03123e21f93.png" alt="" style="max-height:578px; box-sizing:content-box;" />


执行完后可以发现 他已经在页面中进行了跳转



<img src="https://i-blog.csdnimg.cn/blog_migrate/252b062659c9e79212ec9ddeb11e0be8.png" alt="" style="max-height:156px; box-sizing:content-box;" />


在这里可以实现多行执行

## ⭐JS的输出

存在这些输出格式

```typescript
使用 window.alert() 弹出警告框。
使用 document.write() 方法将内容写到 HTML 文档中。
使用 innerHTML 写入到 HTML 元素。
使用 console.log() 写入到浏览器的控制台。
```

一个一个实现

```cobol
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
<script>
    window.alert("WARNING!!!");
</script>
</body>
</html>
```

下面可以写入一个时间在html中

写入参数 需要文档加载完毕后操作

```cobol
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
<script>
    document.write(Date())
</script>
</body>
</html>
```

下面是对元素的控制

```cobol
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <p id="check">我的第一个段落。</p>
 
    <button type='button' onclick="myFunction()">点我</button>
 
    <script>
        function myFunction() {
            document.getElementById('check').innerHTML = Date();
        }
    </script>
</body>
</html>
```

## JS的语法

首先就是定义参数

```cobol
var a,b
 
a= 4
b = 'four'
```

JS的注释是 //

在 // 后面的JS 不会执行

 [JavaScript 语法 | 菜鸟教程](https://www.runoob.com/js/js-syntax.html) 

```cobol
var length = 16;                                  // Number 通过数字字面量赋值 
var points = x * 10;                              // Number 通过表达式字面量赋值
var lastName = "Johnson";                         // String 通过字符串字面量赋值
var cars = ["Saab", "Volvo", "BMW"];              // Array  通过数组字面量赋值
var person = {firstName:"John", lastName:"Doe"};  // Object 通过对象字面量赋值
```

JavaScript 对大小写是敏感的。

```kotlin
break 	用于跳出循环。
catch 	语句块，在 try 语句块执行出错时执行 catch 语句块。
continue 	跳过循环中的一个迭代。
do ... while 	执行一个语句块，在条件语句为 true 时继续执行该语句块。
for 	在条件语句为 true 时，可以将代码块执行指定的次数。
for ... in 	用于遍历数组或者对象的属性（对数组或者对象的属性进行循环操作）。
function 	定义一个函数
if ... else 	用于基于不同的条件来执行不同的动作。
return 	退出函数
switch 	用于基于不同的条件来执行不同的动作。
throw 	抛出（生成）错误 。
try 	实现错误处理，与 catch 一同使用。
var 	声明一个变量。
while 	当条件语句为 true 时，执行语句块。
```

这是JS函数的介绍

多行注释 /**/

对于变量的命名 这里也需要注意

```crystal
 
变量必须以字母开头
变量也能以 $ 和 _ 符号开头（不过我们不推荐这么做）
变量名称对大小写敏感（y 和 Y 是不同的变量）
```



其次注意一下数组的创建

```cobol
var cars=new Array();
cars[0]="Saab";
cars[1]="Volvo";
cars[2]="BMW";
 
或者 (condensed array):
var cars=new Array("Saab","Volvo","BMW");
```

对象的创建

```cobol
var person={
firstname : "John",
lastname  : "Doe",
id        :  5566
};
 
对象属性有两种寻址方式：
实例
name=person.lastname;
name=person["lastname"]; 
```

这里注意对象的寻址即可

## ⭐⭐JS的对象

这个就比较重要了

这里直接引用菜鸟教程的例子



<img src="https://i-blog.csdnimg.cn/blog_migrate/d14fc5327c0b1e687baafe64106bb097.png" alt="" style="max-height:456px; box-sizing:content-box;" />


属性就是汽车的组成

方法就是使用汽车的方式

对象就是一个大的汽车

在JS中任何事务都可以是一个对象

```cobol
var person = {firstName:"John", lastName:"Doe", age:50, eyeColor:"blue"};
 
这里 我们可以通过
 
person.firstName 获取到 John
 
其他同理
 
或者可以使用
 
person[firstName] 获取到 John
```

下面是函数作为方法存储在对象内

```kotlin
var person = {
    firstName: "John",
    lastName : "Doe",
    id : 5566,
    fullName : function() 
	{
       return this.firstName + " " + this.lastName;
    }
};
```

我们发现 fullName 是一个函数

这里就是方法

```cobol
我们可以通过
 
person.fullName() 调用
 
 
 
document.getElementById("demo1").innerHTML = "不加括号输出函数表达式："  + person.fullName;
document.getElementById("demo2").innerHTML = "加括号输出函数执行结果："  +  person.fullName();
 
两个调用方式 不一样
 
输出内容是
 
不加括号输出函数表达式：function() { return this.firstName + " " + this.lastName; }
 
加括号输出函数执行结果：John Doe
```

这些就是JS最基础的对象了

我写的也很基础

## JS函数

最简单的调用函数方式

```cobol
function test(){
    //代码段
}
```

如果是带参数的函数

```scss
function test(a,b){
    alert(a+b);
}
```

这样就可以执行带参数的内容

然后就是返回值

使用return即可

```css
function test(a,b){
    retrun a+b;
}
```

然后就是全局和局部变量

这里还有一个 可配置全局和不可配置全局

```cobol
var var1 = 1; // 不可配置全局属性
var2 = 2; // 没有使用 var 声明，可配置全局属性
 
console.log(this.var1); // 1
console.log(window.var1); // 1
console.log(window.var2); // 2
 
delete var1; // false 无法删除
console.log(var1); //1
 
delete var2; 
console.log(delete var2); // true
console.log(var2); // 已经删除 报错变量未定义
```

## JS的作用域

其实就是全局变量这些

```javascript
myFunction();
document.getElementById("demo").innerHTML = "carName 的类型是：" +  typeof carName;
function myFunction() 
{
    var carName = "Volvo";
}
 
这里我们发现 我们在局部变量 定义前就已经通过innerHTML 输出 这里是不可以的
 
输出内容是carName 的类型是：undefined
```

但是这里注意

```javascript
myFunction();
document.getElementById("demo").innerHTML = "carName 的类型是：" +  typeof carName;
function myFunction() 
{
    carName = "Volvo";
}
```

这里是可以的 有什么区别呢 就是 carName前是否存在var

如果没有var  就默认为全局变量

GPT的回答

```typescript
当使用 var 关键字声明变量时，该变量会被限定在当前的函数作用域或全局作用域中。
但是，如果在声明变量时没有使用 var、let 或 const，JavaScript 引擎会将其视为全局变量
并将其添加到全局对象（在浏览器环境下是 window 对象）的属性中
```

## ⭐JS的事件

这里我感觉是目前用户遇到js最多的地方了

通过html的事件 执行js指令

```less
HTML 页面完成加载
HTML input 字段改变时
HTML 按钮被点击
```

```cobol
<button onclick="getElementById('demo').innerHTML=Date()">现在的时间是?</button>
 
这里是通过点击 修改 id=demo的内容
 
 
<button onclick="this.innerHTML=Date()">现在的时间是?</button>
 
而通过 this 是修改当前 button的指令
```

下面是可以操作的事件

```less
onchange 	HTML 元素改变
onclick 	用户点击 HTML 元素
onmouseover 	鼠标指针移动到指定的元素上时发生
onmouseout 	用户从一个 HTML 元素上移开鼠标时发生
onkeydown 	用户按下键盘按键
onload 	浏览器已完成页面的加载
```

就是 上面的内容执行的时候 就会执行js

## JS字符串

```delphi
我们可以通过类似python的format的方式 在字符串中加入变量
 
const name='hel'
 
const year='17'
 
const message= `My name is ${name} and I'm ${year} years old.`;
```

我们发现是使用 ${}来进行操作

## JS条件运算符

其他都是一样的

这里知识介绍一下 条件运算符

```cobol
name=(age<18)?"Vam":"Same"
 
这里通过比对age是否小于18来输出
 
如果小于 就输出Vam  如果大于 就输出 Same
```

## JS IF ELSE  For

```cobol
<script>
function myFunction(){
	var x="";
	var time=new Date().getHours();
	if (time<20){
		x="Good day";
    }
	document.getElementById("demo").innerHTML=x;
}
</script>
 
通过javascript 获取到时间（精确到小时） 然后通过document输出
```

这里介绍一下for循环

其实和c差不多

```cobol
for(var i-0;i<cars.length;i++){
 
    decoument.write('cars[i]')
 
}
```

```cobol
for - 循环代码块一定的次数
for/in - 循环遍历对象的属性
while - 当指定的条件为 true 时循环指定的代码块
do/while - 同样当指定的条件为 true 时循环指定的代码块
```

```kotlin
break 语句用于跳出循环。
 
continue 用于跳过循环中的一个迭代。
```

这些在其他代码中也都学过了

基础内容差不多就这些了，这个文章只是个人不做开发了解javascrip

所以东西是很简单的

照样

我们来编写一个js文件完善之前html的页面

1.js

```cobol
function check() {
    var name = document.getElementById("name");
    var passwd = document.getElementById("passwd");
    var oError = document.getElementById("error");
    var isError = true;
 
    if (name.value.trim() === '') {
        window.alert("账号不能为空");
        isError = false
        return
    }else if (passwd.value.trim() === '') {
        window.alert("密码不能为空");
        isError = false
        return
    }else if (name.value.length > 20 || name.value.length < 3) {
        oError.innerHTML = "账号长度不对";
        isError = false;
        return
    } else {
        // 向后端发送验证请求
        // 假设使用AJAX进行异步请求
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '/test-web/dir.php', true); 
        xhr.setRequestHeader('Content-Type', 'application/json');
 
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText);
                    if (response.success) {
                        window.alert("登录成功");
                    } else {
                        oError.innerHTML = response.errorMessage;
                    }
                } else {
                    window.alert("登录请求失败");
                }
            }
        };
 
        var data = JSON.stringify({
            username: name.value.trim(),
            password: passwd.value.trim()
        });
 
        xhr.send(data);
    }
    setTimeout(function() {
        error.innerHTML = "";
    }, 2000);
}
```

index.html

```cobol
<<!DOCTYPE html>
<html lang="en">
<!---flag{fuc3-yo3}-->
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- <script type="text/javascript" src="js/1.js"></script> -->
    <title>学习测试一下网站解法</title>
</head>
<body>
    <h1> 我需要学会html语言基本 </h1>
    <hr>
    <h2> 基础的东西我也要会</h2>
    <p>  段落和标题的区别
        就是这个 其实我就是正文 </p>
        <hr>
    <p> 不同段落需要 重新获取p标签</p>
    <a href="帅照.jpg" download>下载帅照</a>
    <p>这是一个段落标签<br>但是我使用br分段</p>
 
 
<p> 这里介绍一下表格</p>
 
 <table border="12">
    <thead>
        <tr>
            <th> id</th>
            <th> name</th>
            <th> passwd</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td> 1</td>
            <td> admin</td>
            <td> admin123</td>
        </tr>
 
    </tbody>
 </table>       
 <p> 这里介绍一下列表</p>
 <ul>
    <li>1111111:</li>
    <li>2222222:</li>
 </ul>
 <form action="/test-web/dir.php" method="post"> 
    <label for="name">用户名</label>
    <input type="text" name="name" id="name">
    <br>
    <label for="passwd">密码:</label>
    <input type="password" name="passwd" id="passwd">
    <br>
    <button type="submit"  onclick="check()">登入</button>
    <p id="error"><br></p>
    <a href="http://127.0.0.1:3000/test-web/zhuce.php">注册</a>
</form>
 
</body>
</html>
```

这里是修改后的 后面的js链接后端是通过gpt生成的