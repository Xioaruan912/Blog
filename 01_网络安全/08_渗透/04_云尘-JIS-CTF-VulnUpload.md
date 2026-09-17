# 云尘-JIS-CTF-VulnUpload

继续做渗透 一样给了c段 开扫



<img src="https://i-blog.csdnimg.cn/blog_migrate/fe260d595fd9302bb52feaee646b4581.png" alt="" style="max-height:432px; box-sizing:content-box;" />


存在一个站点 去看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/a37bd0ba96a4dddba9acea636c475bb8.png" alt="" style="max-height:596px; box-sizing:content-box;" />


扫一下吧



<img src="https://i-blog.csdnimg.cn/blog_migrate/a4c4447141208ce3da3b69dbdbb452a4.png" alt="" style="max-height:149px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/9f619e3f550f10b09209e04a8c0aa64e.png" alt="" style="max-height:142px; box-sizing:content-box;" />




第一个flag出来了

存在robots.txt 去看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/7464f7b17ec7a8d8aed9d72f82a6c1c9.png" alt="" style="max-height:205px; box-sizing:content-box;" />


admin 页面源代码第二个flag和账号密码



<img src="https://i-blog.csdnimg.cn/blog_migrate/949a70bd96c2103a2856d305a335ec76.png" alt="" style="max-height:400px; box-sizing:content-box;" />


登入



<img src="https://i-blog.csdnimg.cn/blog_migrate/f3ccc019b2e33b1fafe8651bf8dd0960.png" alt="" style="max-height:437px; box-sizing:content-box;" />


就一个上传点

这不明显死了哈哈哈哈哈哈哈

直接开喽



<img src="https://i-blog.csdnimg.cn/blog_migrate/93a12e267a02f1171f487a747cb4fc77.png" alt="" style="max-height:683px; box-sizing:content-box;" />


上传修改后缀一气呵成

发现只有success 但是我们刚刚robots存在upload我们去看看

拼接

```cobol
http://172.25.0.13/uploaded_files/1.php  后面是自己的文件名
```

成功咯 getshell 进去看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/a77adb464018d2c1c8950ab18f39126d.png" alt="" style="max-height:214px; box-sizing:content-box;" />


得到第三个了 这里提示我们读取flag文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/8170b6493b439b4a500d3216e786d178.png" alt="" style="max-height:76px; box-sizing:content-box;" />


权限不够咯 要提权并且上面提示我们去 technawi的密码

我们看看这个用户的文件

```cobol
find / -user technawi -type f 2>/dev/null
 
错误输出到黑洞
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/1bf0992bdca71bc7aeeac1185177b56b.png" alt="" style="max-height:106px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/c94e13945754993a84fcc533ba604b7e.png" alt="" style="max-height:94px; box-sizing:content-box;" />


自己有提权的文件耶

但是不能执行 去看看其他的



<img src="https://i-blog.csdnimg.cn/blog_migrate/373b5a92de00bf81dab78853335faf40.png" alt="" style="max-height:220px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/6caca7aa17c1accd2c1fead4632cbbed.png" alt="" style="max-height:78px; box-sizing:content-box;" />


获取到咯

这里我们就获取了账号密码

然后我们在最开始 可以知道 开起来了ssh

所以我们可以链接看看

```crystal
ssh technawi@172.25.0.13
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/41ef7d4bc927b583a1a7b46571dd8298.png" alt="" style="max-height:173px; box-sizing:content-box;" />


进去咯

可以直接通过账号密码root

```undefined
sudo su
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/bcd1bfe5c8105b826d61e800a7554b6f.png" alt="" style="max-height:145px; box-sizing:content-box;" />


结束

这个靶场还是很简单的