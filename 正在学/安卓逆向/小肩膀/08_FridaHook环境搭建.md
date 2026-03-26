Hook就是可以覆写 可以函数 执行后 就触发Hook

# Python安装

首先你需要存在Python

这里我们先用Python3.8的

我这里是通过 Conda 进行Python的版本控制

```
conda create -n firda python=3.8
```

构建完毕调用即可

```
conda activate firda
```

# windows-frida安装

```
pip install frida
pip install frida-tools
```

只需要一行即可安装全部内容

那么我们验证一下是否安装成功

```
(firda) PS -> frida --version
17.8.3
(firda) PS -> python
Python 3.8.20 (default, Oct  3 2024, 15:19:54) [MSC v.1929 64 bit (AMD64)] :: Anaconda, Inc. on win32
Type "help", "copyright", "credits" or "license" for more information.
>>> import frida
>>>
```

如果输出内容和我差不多  也就没有报错 那么就是ok的

我们得到了 frida的版本 我们下载手机的服务端也必须是这个版本的`17.8.3`

```
https://github.com/frida/frida/releases
```

因为我这里还是虚拟机 所以我安装的是x86的

