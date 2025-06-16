# [GWCTF 2019]枯燥的抽奖 mt_rand 伪随机数

这里又遇见了伪随机数

看似是随机的 但是通过固定种子 就可以实现 同一批次的数字



“就例如我的世界的种子 一样 一个种子 生成的世界是一样的”



<img src="https://i-blog.csdnimg.cn/blog_migrate/5c6f82248ab3d90bbd7b252af444dfdc.png" alt="" style="max-height:539px; box-sizing:content-box;" />


看看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/a800f736af13410865ea9e0a222da653.png" alt="" style="max-height:679px; box-sizing:content-box;" />


访问ckeck.php



<img src="https://i-blog.csdnimg.cn/blog_migrate/345d94bbad2ddc001402c32691633413.png" alt="" style="max-height:622px; box-sizing:content-box;" />


出现了 代码

```cobol
for ( $i = 0; $i < $len1; $i++ ){
    $str.=substr($str_long1, mt_rand(0, strlen($str_long1) - 1), 1);       
} 
 
处理随机数 就是我们需要的key
```

```php
$str_show = substr($str, 0, 10);
echo "<p id='p1'>".$str_show."</p>"; 
 
输出 现在的随机数
```

我们可以通过随机数来计算 种子数

首先需要将字符转变为 数字 让工具去随机

```cobol
str1 ='4BvXIebEIq'
str2 = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
result =''
 
 
length = str(len(str2)-1)
for i in range(0,len(str1)):
    for j in range(0,len(str2)):
        if str1[i] ==  str2[j]:
            result += str(j) + ' ' +str(j) + ' ' + '0' + ' ' + length + ' '
            break
 
 
print(result)
 
```

其次使用工具



<img src="https://i-blog.csdnimg.cn/blog_migrate/f3908fe3e00996380ba2967dce49e76b.png" alt="" style="max-height:212px; box-sizing:content-box;" />


获取到种子 然后 在 php7.1以上的环境运行

```php
<?php
mt_srand(320641180);
$str_long1 = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
$str='';
$len1=20;
for ( $i = 0; $i < $len1; $i++ ){
    $str.=substr($str_long1, mt_rand(0, strlen($str_long1) - 1), 1);       
}
echo "<p id='p1'>".$str."</p>";
echo phpinfo();
 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/9ffdb57a5997d603a67a14be3e4c22b3.png" alt="" style="max-height:385px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/77b7881c31fb390f8211e436dd47001d.png" alt="" style="max-height:611px; box-sizing:content-box;" />


得到flag