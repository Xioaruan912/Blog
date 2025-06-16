# CTFshow web入门 爆破

## web21  bp 攻击模块的迭代器



<img src="https://i-blog.csdnimg.cn/blog_migrate/a511ce2f105392079112eadaa39feae5.png" alt="" style="max-height:245px; box-sizing:content-box;" />




输入账号密码抓包发现下面存在一个base64编码

我输入的是 123 123



发现就是base加密

账号 密码

那我们怎么通过intruder模块 自动变为 base64呢



<img src="https://i-blog.csdnimg.cn/blog_migrate/3e0f36c6aa0f9189eff45060c6a50b89.png" alt="" style="max-height:399px; box-sizing:content-box;" />


然后去payload------>customiterator(自定义迭代器)



<img src="https://i-blog.csdnimg.cn/blog_migrate/b66b415f1d431124f89fecbb5421f1c5.png" alt="" style="max-height:176px; box-sizing:content-box;" />


位置1导入admin



<img src="https://i-blog.csdnimg.cn/blog_migrate/4a85eaa2e0d54b073827395f7b9a8507.png" alt="" style="max-height:355px; box-sizing:content-box;" />






因为是   账号:密码   这个组合 所以位置2 选择 :



<img src="https://i-blog.csdnimg.cn/blog_migrate/7df3f1fae490169c180d67e99713f356.png" alt="" style="max-height:176px; box-sizing:content-box;" />


位置3

再一次导入字典



<img src="https://i-blog.csdnimg.cn/blog_migrate/ef583be116966eb351d1c0d32fcb1772.png" alt="" style="max-height:287px; box-sizing:content-box;" />




选择编码 我们在下面的进行编码选择



<img src="https://i-blog.csdnimg.cn/blog_migrate/5b14f8719933a74198e087a96685af82.png" alt="" style="max-height:259px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/5fabc332e8774876c0e6d616a2297a99.png" alt="" style="max-height:123px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/757bc4bf43e5566c93b343b45e3d636d.png" alt="" style="max-height:204px; box-sizing:content-box;" />


还有记得取消自动url编码



<img src="https://i-blog.csdnimg.cn/blog_migrate/e0f46839a6c550cec6954b14c41f6d27.png" alt="" style="max-height:197px; box-sizing:content-box;" />


然后直接开始就可以了



<img src="https://i-blog.csdnimg.cn/blog_migrate/7dfacf0054ae429a7741d5dfd4ade52d.png" alt="" style="max-height:511px; box-sizing:content-box;" />




## web22 域名也可以爆破

 [Release Layer5.0 SAINTSEC · euphrat1ca/LayerDom ainFinder · GitHub](https://github.com/euphrat1ca/LayerDomainFinder/releases/tag/3) 



<img src="https://i-blog.csdnimg.cn/blog_migrate/2427d19b47bfccc067f32c135fded570.png" alt="" style="max-height:283px; box-sizing:content-box;" />


但是我没找到flag

## web23



<img src="https://i-blog.csdnimg.cn/blog_migrate/e7cc28c9fd8127d38c0808a3fa2d291e.png" alt="" style="max-height:713px; box-sizing:content-box;" />


## web24



<img src="https://i-blog.csdnimg.cn/blog_migrate/8ac73b724cbb74bed475100f7bbd4dbb.png" alt="" style="max-height:315px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/4a34d132c0397dd823b55f65a81fb205.png" alt="" style="max-height:282px; box-sizing:content-box;" />


## web25

首先对代码进行查看

```php
include("flag.php");
if(isset($_GET['r'])){
    $r = $_GET['r'];
上面都是读取
    mt_srand(hexdec(substr(md5($flag), 0,8)));
 mt_srand 是一个随机数生成器
生成出来的内容为 mt_rand()
其中的种子是 
对md5后的flag的0到8进行十六进制转换的值
    $rand = intval($r)-intval(mt_rand());
设置rand为 输入的r - 这个随机数
    if((!$rand)){
如果 rand为0
        if($_COOKIE['token']==(mt_rand()+mt_rand())){
            echo $flag;
        }
就输出flag
 
    }else{
        echo $rand;
不然就输出 随机数
 
    }
}else{
    highlight_file(__FILE__);
    echo system('cat /proc/version');
} 
```

这个时候 我们读懂了代码

要的就是我们输入的 r - 随机数 =0

我们先输入一个 0 看看

```cobol
?r=0
 
-1403888972
```

说明现在的 随机数即3（mt_rand）= 1403888972

那我们可以使用工具

 [GitHub - openwall/php_mt_seed: PHP mt_rand() seed cracker](https://github.com/openwall/php_mt_seed) 来爆破



<img src="https://i-blog.csdnimg.cn/blog_migrate/0c4f1937f7c2b70a90b00b49beadfe34.png" alt="" style="max-height:358px; box-sizing:content-box;" />


得到了这些数值

那我们可以写一个php 来看看是什么得到了 1403888972

```php
<?php
$num=4266567617;
mt_srand($num);
echo mt_rand();
 
 
    
 
?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7b1c18a35e3bd4baeded959551374802.png" alt="" style="max-height:293px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/22258a5904f5e7f179c8effdaf3ede2d.png" alt="" style="max-height:293px; box-sizing:content-box;" />


最后排除到了 两个

这个时候 我们就知道了 mt_rand=4266567617 或者3811577552



```scss
 if((!$rand)){
        if($_COOKIE['token']==(mt_rand()+mt_rand())){
            echo $flag; 
 
 
这里取得了 两次的 mt_rand() 
 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/54677b9ede27548876e25efa03f180ce.png" alt="" style="max-height:297px; box-sizing:content-box;" />


发现 每一次的值是不一样的 所以他总共是取了3次值

这里是第2 3 次

那我们写个代码来测试



<img src="https://i-blog.csdnimg.cn/blog_migrate/903dea50c3b94ed8dde8d19e8ccfea74.png" alt="" style="max-height:449px; box-sizing:content-box;" />


测试看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/9e9c7e9a8e72b4451906eb152e8513a5.png" alt="" style="max-height:98px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/38412fabb1eacf76015c5c7b554b0414.png" alt="" style="max-height:88px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/6fd451a3e1c9598c8c246d2e82db520f.png" alt="" style="max-height:234px; box-sizing:content-box;" />


发现成功了

## web26

爆破pass 即可

## web27 bp的日期爆破



<img src="https://i-blog.csdnimg.cn/blog_migrate/a6b6641c41da75c969a5e26c68cd9f22.png" alt="" style="max-height:435px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/e6f378a8ba4f5c35531f97bbdc6c79d1.png" alt="" style="max-height:293px; box-sizing:content-box;" />


抓包

<img src="https://i-blog.csdnimg.cn/blog_migrate/b17310ff0a27c04e72b372fd2909d5ae.png" alt="" style="max-height:441px; box-sizing:content-box;" />




最后爆破完成时 19900201

## web28



<img src="https://i-blog.csdnimg.cn/blog_migrate/05aa80c283a3699982c2cc88c78a9a83.png" alt="" style="max-height:200px; box-sizing:content-box;" />


我们爆破目录看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/4ed7c725116a863cea037fccf0510f50.png" alt="" style="max-height:713px; box-sizing:content-box;" />