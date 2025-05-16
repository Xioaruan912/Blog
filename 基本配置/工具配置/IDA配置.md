# 插件推荐

https://github.com/polymorf/findcrypt-yara 快速查找加解密

https://github.com/JusticeRage/Gepetto  模型直接分析函数





# 修改IDApython环境

需要使用框架 所以就是不能使用conda 或者可以试试看环境变量 但是我没有测试过

https://www.cnblogs.com/hengdin/articles/18810541

现在主要是macos遇到

```
brew install python@3.11
```

然后

```
cd "/Applications/IDA Professional 9.0.app/Contents/MacOS"
./idapyswitch --force-path "/opt/homebrew/Frameworks/Python.framework/Versions/3.11/Python"
```

这个路径 大概就是这个 如果不知道就 通过 idapyswitch就可以知道了

这样在后面pip就需要进入这个环境

```
/opt/homebrew/Frameworks/Python.framework/Versions/3.11/bin/python3.11
/opt/homebrew/Frameworks/Python.framework/Versions/3.11/bin/pip3
```



# MCP

https://github.com/mrexodia/ida-pro-mcp

```
conda create -n mcp python==3.12
conda activate mcp
pip install --upgrade git+https://github.com/mrexodia/ida-pro-mcp
ida-pro-mcp --install
```

构建VScode

下载 Cline AI对话

配置Key

https://platform.deepseek.com/usage 10块钱就可以用了

![image-20250429094848538](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250429094848538.png)

配置后打开IDA 

# MACOS配置远程调试exe

首先去

```
/Applications/IDA Professional 9.0.app/Contents/MacOS/dbgsrv
```

下载exe到windows上

执行

```
win64_remote64.exe -v 然后就会开放端口
```

如果服务器最好防火墙开放

```
netsh advfirewall firewall add rule name="IDA Remote" dir=in action=allow protocol=TCP localport=23946
```

然后配置ida

![image-20250505212218555](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250505212218555.png)

不要从盘符开始 ok即可

# Windows安装ida9

# MACOS安装插件

安装https://github.com/polymorf/findcrypt-yara为例子

```
找到之前到idapython环境
/opt/homebrew/Frameworks/Python.framework/Versions/3.11/bin/pip3 install yara-python
```

下载项目的py和rules文件 放入 这个目录下即可 要里面macos的不要外面的

```
/Applications/IDA Professional 9.0.app/Contents/MacOS/plugins
```

