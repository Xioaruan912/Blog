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