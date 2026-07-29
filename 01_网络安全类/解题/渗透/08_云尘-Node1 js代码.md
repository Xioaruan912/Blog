# 云尘-Node1 js代码

继续做题

拿到就是基本扫一下

```cobol
nmap -sP 172.25.0.0/24 
 
nmap -sV -sS -p- -v 172.25.0.13
```

然后顺便fscan扫一下咯

nmap:



<img src="https://i-blog.csdnimg.cn/blog_migrate/751cc38f0ff58392890536babee4aee6.png" alt="" style="max-height:235px; box-sizing:content-box;" />


fscan:



<img src="https://i-blog.csdnimg.cn/blog_migrate/35e42295471ff9b3fe2106722d65c524.png" alt="" style="max-height:345px; box-sizing:content-box;" />


还以为直接getshell了 老演员了 其实只是302跳转 所以我们无视 只有一个站 直接看就行了



<img src="https://i-blog.csdnimg.cn/blog_migrate/d56a75eae297b306f57ba12f3bdcd291.png" alt="" style="max-height:104px; box-sizing:content-box;" />


扫出来了两个目录 但是没办法 都是要跳转 说明还是需要登入才可以



<img src="https://i-blog.csdnimg.cn/blog_migrate/e7b0374980d96effcf1f24adf24fb062.png" alt="" style="max-height:242px; box-sizing:content-box;" />


不存在sql注入

源代码中也没有提示 奇了怪了

看看存不存在接口吧

用js扫一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/fd6eb9b83c8ebb0992f4038a95ae7b80.png" alt="" style="max-height:283px; box-sizing:content-box;" />


访问看看咯



<img src="https://i-blog.csdnimg.cn/blog_migrate/976c115a073c3910216578dad505d36c.png" alt="" style="max-height:498px; box-sizing:content-box;" />


这账号密码不就出来了 看看这个是啥加密 多半是hash 我们使用hash识别看看

```python
hash-identifier
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d6ac85f181b9e8097dcb7dabbbe0d256.png" alt="" style="max-height:306px; box-sizing:content-box;" />


可能是256 去解密看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/cf1eefe8009f0baa696b5cbe514ced3a.png" alt="" style="max-height:188px; box-sizing:content-box;" />


这不就出来了



<img src="https://i-blog.csdnimg.cn/blog_migrate/b97fe4867cf322ba923622e630bbd866.png" alt="" style="max-height:301px; box-sizing:content-box;" />


其他用户

```cobol
myP14ceAdm1nAcc0uNT
 
manchester
```

登入网站

然后下载的时候靶场炸了

差不多就是base64解密 然后通过 file 识别为zip

然后通过爆破zip密码 获取源代码

然后再 去 app.js中查看ssh链接

密码:5AYRft73VtFpc84k  用户 mark

最后一样 通过searchsploit 查找漏洞提权即可

后续不写了