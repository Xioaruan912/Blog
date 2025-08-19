# [GKCTF 2021]easycms 禅知cms

一道类似于渗透的题目 记录一下

首先扫描获取 登入界面 admin/12345登入



<img src="https://i-blog.csdnimg.cn/blog_migrate/6183e8a74618ead095b7ca3d8c1a1797.png" alt="" style="max-height:765px; box-sizing:content-box;" />


来到了后台

然后我们开始测试有无漏洞点

## 1.文件下载

设计 自定义 导出 然后进行抓包



<img src="https://i-blog.csdnimg.cn/blog_migrate/dfc76f5e4af2baa73d72c9126df0190d.png" alt="" style="max-height:719px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/c39b74284e4e47a6347fc0716a21115e.png" alt="" style="max-height:360px; box-sizing:content-box;" />


解密后面的内容



<img src="https://i-blog.csdnimg.cn/blog_migrate/20c43f27345d251f6742476d85adb4df.png" alt="" style="max-height:602px; box-sizing:content-box;" />


发现是绝对路径了 所以这里我们要获取 flag 就/flag即可

```cobol
L2ZsYWc=
```

```cobol
/admin.php?m=ui&f=downloadtheme&theme=L2ZsYWc=
```

## 2.文件上传

设计 自定义 首页

<img src="https://i-blog.csdnimg.cn/blog_migrate/b630078090b48ee19237448a937c039c.png" alt="" style="max-height:390px; box-sizing:content-box;" />


如果直接上传 会报错



<img src="https://i-blog.csdnimg.cn/blog_migrate/a062bf24a1fd245792583a25410e8841.png" alt="" style="max-height:417px; box-sizing:content-box;" />


需要我们先建立这个文件

设计——组件——素材库——上传素材

然后传递一个文件 然后修改名字 ../../../../../system/tmp/qdma (每个人不一样)



<img src="https://i-blog.csdnimg.cn/blog_migrate/71c775051afa021deaa81792960ab35f.png" alt="" style="max-height:376px; box-sizing:content-box;" />


这个时候 再去写入php即可

system('cat /flag');



<img src="https://i-blog.csdnimg.cn/blog_migrate/67b09806d8a24905729fd4f2b852fe03.png" alt="" style="max-height:508px; box-sizing:content-box;" />


## 3.直接读取

通过我们上面创建文件 我们就可以通过 高级 直接写入php代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/f87f973e5b019c93799522a4ff91352b.png" alt="" style="max-height:318px; box-sizing:content-box;" />


但是这个实现失败了 不止为啥