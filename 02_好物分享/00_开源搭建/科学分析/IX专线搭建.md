```
本研究仅用于合法合规的网络传输过程分析与技术研究，不涉及任何非法用途。
```

三台机器 大厂云 IX 和 落地

如果IX出口自带 落地 就可以不需要 但是我们还是希望 IX上只转发 不搭建

这里过一下搭建流程

# 阿里云配置

这里使用阿里云配置

通过下面脚本实现 重构系统

```
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh || wget -O reinstall.sh $_
bash reinstall.sh debian 13
```

等待重构完成 即可 

```
apt install unzip curl wget git sudo -y
```

安装 转发脚本

```
curl -sSL -o realm.sh "https://raw.githubusercontent.com/Xioaruan912/Xcript/main/sh/realm.sh" && chmod +x realm.sh && ./realm.sh && rm realm.sh
```

这里就暂时配置完毕

# IX配置

也可以dd  安装脚本

```
curl -sSL -o realm.sh "https://raw.githubusercontent.com/Xioaruan912/Xcript/main/sh/realm.sh" && chmod +x realm.sh && ./realm.sh && rm realm.sh
```



# 落地配置

这里落地只加速 ssh 所以不展开
