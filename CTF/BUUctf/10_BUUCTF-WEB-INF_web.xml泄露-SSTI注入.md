# BUUCTF-WEB-INF/web.xml泄露-SSTI注入

第八周

**目录**

[TOC]



## WEB

### [RoarCTF 2019]Easy Java

打开环境



<img src="https://i-blog.csdnimg.cn/blog_migrate/97cfbb7cd8f6ca640bd276cbbae114c2.png" alt="" style="max-height:515px; box-sizing:content-box;" />


发现是登入界面 看看能不能sql注入



<img src="https://i-blog.csdnimg.cn/blog_migrate/f1f9372ee7b90354bb08ae7e0bd1c807.png" alt="" style="max-height:292px; box-sizing:content-box;" />


发现是做不到的

我们看看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/3032e0fda86ce71c0ba12841f3e9523d.png" alt="" style="max-height:271px; box-sizing:content-box;" />


发现有两个界面 第一个我们刚刚去过了 看看下面这个



<img src="https://i-blog.csdnimg.cn/blog_migrate/9ea8687dea02383dcaa8ae3ff86b27e0.png" alt="" style="max-height:207px; box-sizing:content-box;" />


返回了这个文件 我们发现docx 是文档文件

看看能不能下载

```cobol
31d39024-b852-4ee7-9743-b9b17fa5494e.node4.buuoj.cn:81/help.docx
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/314955088d6451ecd479a9315921824e.png" alt="" style="max-height:256px; box-sizing:content-box;" />


显然没有这么简单

但是这道题目不是耍我们 是给我们发现 我们能够从里面下载文件

因为这道题的题目是java

java有一个漏洞 和git差不多的漏洞

#### WEB-INF/web.xml泄露

其实web-inf就是一个文件夹 这个文件夹里存放着很多敏感文件

```cobol
/WEB-INF/web.xml：Web应用程序配置文件，描述了 servlet 和其余的应用组件配置及命名规则。
/WEB-INF/classes/：含了站点全部用的 class 文件，包括 servlet class 和非servlet class，他们不能包含在 .jar文件中
/WEB-INF/lib/：存放web应用须要的各类JAR文件，放置仅在这个应用中要求使用的jar文件,如数据库驱动jar文件
/WEB-INF/src/：源码目录，按照包名结构放置各个java文件。
/WEB-INF/database.properties：数据库配置文件
```

这些文件都是包含着敏感信息 如果我们有办法得到访问这个文件夹的权限

我们就可以看到这些文件

我们可以先试试看能不能访问这些文件

#### WEB-INF/web.xml泄露原因

因为web有的时候需要很多服务器来共同维护 如果有的服务器对静态资源的目录或文件的映射配置不

当，就容易出现这个泄露

#### WEB-INF/web.xml泄露利用方法

先看看能不能访问/WEB-INF/web.xml文件 如果可以访问 我们就可以发现命名规则 然后通过

/WEB-INF/classes/ 来下载文件

#### 解决方法

修改Nginx配置文件禁止访问WEB-INF目录



我们得到了这个办法 就开始看看哪里可以访问 /WEB-INF/web.xml



<img src="https://i-blog.csdnimg.cn/blog_migrate/972c90d9e05db7ea1214317f767c40e6.png" alt="" style="max-height:86px; box-sizing:content-box;" />


我们能发现 在这里有post的方法 因为经过尝试 get无法访问这个文件夹

我们看看post能不能



<img src="https://i-blog.csdnimg.cn/blog_migrate/26e6a04669bde5b715bbae99391564c6.png" alt="" style="max-height:218px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/200bcfb934959261505cba9629ceb4b7.png" alt="" style="max-height:165px; box-sizing:content-box;" />


记事本打开



<img src="https://i-blog.csdnimg.cn/blog_migrate/2d2b363d50affd5c26013c9f43587a9d.png" alt="" style="max-height:237px; box-sizing:content-box;" />


能发现flag的命名和类存放位置

我们可以使用

```cobol
/WEB-INF/classes/com/wm/ctf/FlagController.class
```

来访问 其实就是访问文件夹



<img src="https://i-blog.csdnimg.cn/blog_migrate/93428fda145580cc348fa65697bfa50f.png" alt="" style="max-height:186px; box-sizing:content-box;" />


得到文件 通过java打开



<img src="https://i-blog.csdnimg.cn/blog_migrate/890b41b10d146955d64fe73d5b2f9c4f.png" alt="" style="max-height:1000px; box-sizing:content-box;" />


发现加密

base64解密



<img src="https://i-blog.csdnimg.cn/blog_migrate/7ee605a317f682d1aeddce06fa754614.png" alt="" style="max-height:361px; box-sizing:content-box;" />


 [CTF常见源码泄漏总结 - JavaShuo](http://www.javashuo.com/article/p-mdrcefaq-nq.html) 

### [BJDCTF2020]The mystery of ip

 [https://www.cnblogs.com/2ha0yuk7on/p/16648850.html#%E6%A8%A1%E6%9D%BF%E5%BC%95%E6%93%8E](https://www.cnblogs.com/2ha0yuk7on/p/16648850.html#%E6%A8%A1%E6%9D%BF%E5%BC%95%E6%93%8E) 

 [服务器端模板注入(SSTI) - 知乎](https://zhuanlan.zhihu.com/p/40452957) 

这题考的是板块注入 SSTI

#### 什么是板块注入 SSTI

其实和sql注入一样 sql注入是通过构造字符串 让我们要比对的字符串变为执行的命令

ssti也是一样的 只不过 ssti是在框架中执行 语言框架对html的渲染 因为对字符串不够严格 就容易变为命令执行

#### 为什么会产生

render_template渲染函数的问题

#### 什么是render_template

是用户和页面交互的函数  页面可以通过用户的操作来展示页面

#### render_template：

如果对用户输入不进行操作

{{}}在Jinja2渲染的时候会对{{}}里面进行操作 例如 {{1+2}} 会被渲染为3  所以SSTI利用了这一点

{{命令}} 来实现注入

开始做题



<img src="https://i-blog.csdnimg.cn/blog_migrate/72dbe64a9707f24dcc88dee7248b6270.png" alt="" style="max-height:533px; box-sizing:content-box;" />


打开网站 发现有其他的页面 看看源代码

访问 flag.php



<img src="https://i-blog.csdnimg.cn/blog_migrate/64700df601efd97f29d77fe96280e91a.png" alt="" style="max-height:372px; box-sizing:content-box;" />


访问hint.php



<img src="https://i-blog.csdnimg.cn/blog_migrate/e9746cc0d5abb00b38e8c12a8239ec42.png" alt="" style="max-height:407px; box-sizing:content-box;" />


在源代码里发现提示



<img src="https://i-blog.csdnimg.cn/blog_migrate/0c7b179a7e3405e702c56e92cb8334e3.png" alt="" style="max-height:309px; box-sizing:content-box;" />


让我们思考如何知道我们ip的 我们一下就想到 X-Forwarded-For

我们抓包看看能不能更改





<img src="https://i-blog.csdnimg.cn/blog_migrate/e381aea421e463333d8d4ac2b8d3823b.png" alt="" style="max-height:241px; box-sizing:content-box;" />


<img src="https://i-blog.csdnimg.cn/blog_migrate/9b83e99299993a5d4626be3311398f9b.png" alt="" style="max-height:350px; box-sizing:content-box;" />


#### 我们为什么能想到是框架注入呢

因为这个是我们完全可控的 我们修改多少就是多少 我们可以先尝试看看能不能写入

因为这里是自动获取 SSTI就是容易在cookie这块自动获取的地方下手脚

我们尝试{{1+2}}



<img src="https://i-blog.csdnimg.cn/blog_migrate/ceb0c1a8a344ff3d34fe3f54f87cac96.png" alt="" style="max-height:290px; box-sizing:content-box;" />


发现完全可以 说明就是SSTI注入

我们开始构造payload

```handlebars
X-Forwarded-For:{{system('ls')}}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5dc4b1a3779ae7f1f422b693e4a1be9c.png" alt="" style="max-height:621px; box-sizing:content-box;" />


发现flag文件 我们开始查看

```handlebars
X-Forwarded-For:{{system('cat /flag.php')}}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b3c2efbb1919e7e5c5094cf13ba857e7.png" alt="" style="max-height:522px; box-sizing:content-box;" />




发现没有回显 应该不会是黑名单 我们先看看根目录再说 实在不行 我们应该可以发现黑名单文件的

我们开始查看根目录

```handlebars
X-Forwarded-For:{{system('ls ../../..')}}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/69d073f001f4a6fbfcf71768c9f52259.png" alt="" style="max-height:513px; box-sizing:content-box;" />


发现这里也有flag 说明刚刚是骗我们的

我们继续访问

```handlebars
X-Forwarded-For:{{system('cat /flag')}}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/822ea0518e0d359711bf68085cc01e8a.png" alt="" style="max-height:573px; box-sizing:content-box;" />


得到flag

## Crypto



### 被劫持的神秘礼物



<img src="https://i-blog.csdnimg.cn/blog_migrate/a22eeb23eb090c0e7a2636b0b7528e12.png" alt="" style="max-height:219px; box-sizing:content-box;" />


这题很简单 流量分析



<img src="https://i-blog.csdnimg.cn/blog_migrate/ea453272747aa6206d7c41b5b5667962.png" alt="" style="max-height:250px; box-sizing:content-box;" />


有一个login

看看里面的账号密码



<img src="https://i-blog.csdnimg.cn/blog_migrate/c4cc450076891b11103e19205c67dca2.png" alt="" style="max-height:142px; box-sizing:content-box;" />


```undefined
adminaadminb
```

MD5小写加密



<img src="https://i-blog.csdnimg.cn/blog_migrate/222f737e58cef7c24b8fb432cefa6c9e.png" alt="" style="max-height:276px; box-sizing:content-box;" />


提交即可

### [BJDCTF2020]认真你就输了

下载文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/cc23002782b540774ffa1a640c18e2d9.png" alt="" style="max-height:177px; box-sizing:content-box;" />


发现pk 解压包 我们改后缀

下来一大堆文件 看看里面 flag

得到flag



<img src="https://i-blog.csdnimg.cn/blog_migrate/2f85ab9d07eca966fac4a850ba831550.png" alt="" style="max-height:486px; box-sizing:content-box;" />