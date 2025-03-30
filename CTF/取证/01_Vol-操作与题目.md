# Vol-操作与题目

**目录**

[TOC]



首先学习基础用法

## 1.查看系统基本信息   imageinfo



```undefined
vol.py -f 路径 imageinfo
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4ade197df6185e1f07ff95d6fa1b7336.png" alt="" style="max-height:303px; box-sizing:content-box;" />


## 2.查看进程命令行   cmdline cmdline

```sql
vol.py -f 路径 --profile=系统版本 cmdline
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/3ffdedb9a06c78c38e3f2379d1d337d9.png" alt="" style="max-height:744px; box-sizing:content-box;" />




```sql
vol.py -f 路径 --profile=版本 cmdscan
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/809bab14c14aeb6427b7ea56a50218c6.png" alt="" style="max-height:138px; box-sizing:content-box;" />


## 3.查看进程信息  pslist

```sql
vol.py -f 路径 --profile=系统 pslist
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/847e11d11b388893605d08a412d6ac92.png" alt="" style="max-height:885px; box-sizing:content-box;" />


通过树的方式返回      pstree

```sql
vol.py -f 路径 --profile=系统 pstree
```

## 4.DLL列表 动态链接库的列表

这里的命令都可以通过 -p 指定 pid   dlllist

```sql
vol.py -f 路径 --profile=系统 dlllist
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/66cf000705f00708211b18a8ba6bb864.png" alt="" style="max-height:852px; box-sizing:content-box;" />


打印出动态链接库的具体信息   ldrmodules

```sql
vol.py -f 路径 --profile=系统 ldrmodules
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a570762f985a227aba5fb0928aa38385.png" alt="" style="max-height:285px; box-sizing:content-box;" />


打印出更具体的内容和十六进制的值    malfind

```sql
vol.py -f 路径 --profile=系统 malfind
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b2f5497cdd1e90eeea45f1fd53469dde.png" alt="" style="max-height:710px; box-sizing:content-box;" />


## 5.查看用户密码信息 开机密码  hashdump

```sql
vol.py -f 路径 --profile=系统 hashdump
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/2b72288e2dbfcc151237ec2eb45c7d1a.png" alt="" style="max-height:136px; box-sizing:content-box;" />


然后通过md5爆破即可

## 6.查看注册表信息   printkey

```sql
vol.py -f 路径 --profile=系统 printkey
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/857bdc3f5c7b8a763bc824465afd466c.png" alt="" style="max-height:698px; box-sizing:content-box;" />




查看注册表的详细信息  hivedump

```sql
vol.py -f 路径 --profile=系统 hivelist
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/dffeb4e4d0b39dc6ab0af0231a8a177e.png" alt="" style="max-height:286px; box-sizing:content-box;" />


查看某个地址的注册表信息   hivedump

```sql
vol.py -f 路径 --profile=系统 hivedump -o 地址
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/6e1ea3e3d2332b0b8340f025f6787f61.png" alt="" style="max-height:926px; box-sizing:content-box;" />


## 7.查看网络信息  netscan

```sql
vol.py -f 路径 --profile=系统 netscan
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/69497bfa15f6aab6ef9a0dab34619bc9.png" alt="" style="max-height:836px; box-sizing:content-box;" />


## 8.查看服务的运行  svcscan

```sql
vol.py -f 路径 --profile=系统 svcscan
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/e6af0c4ad3eed1ea77fcfae9f492c01a.png" alt="" style="max-height:550px; box-sizing:content-box;" />


## 9.查看环境变量  envars

```sql
vol.py -f 路径 --profile=系统 envars
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d559b429ee58fa98bf910b8d3e00eb83.png" alt="" style="max-height:623px; box-sizing:content-box;" />


## 10.进程缓存的文件  filescan

```sql
vol.py -f 路径 --profile=系统 filescan
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/00ead82ff1315e3c7f7be90c6850994d.png" alt="" style="max-height:608px; box-sizing:content-box;" />


## 11.pslist-----memdump   提取进程

首先通过pslist

然后提取

```sql
vol.py -f 路径 --profile=系统 memdump -p 指定的pid   -D 输出的目录
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4a47c058ea86643b60a59961d64e6783.png" alt="" style="max-height:110px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/484a614559af7ef1d6c63b20287e0530.png" alt="" style="max-height:256px; box-sizing:content-box;" />


## 12.filescan-----dumpfiles  提取进程

首先通过

然后提取

```sql
vol.py -f 路径 --profile=系统 dumpfiles -Q 指定的偏移量  -D 输出的目录
```

## 题目

## [OtterCTF 2018]

### 查看主机名

```vbnet
Let's start easy - whats the PC's name and IP address?
```

ip地址可以通过 netscan取得



<img src="https://i-blog.csdnimg.cn/blog_migrate/08818db88e6357791778443f547ef694.png" alt="" style="max-height:460px; box-sizing:content-box;" />


所以是 192.168.202.131

主要是主机名

我们无法直接获取

```undefined
通过注册表 hivelist
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/dd028900832ff0c5f96c2c3182d6e648.png" alt="" style="max-height:223px; box-sizing:content-box;" />


我们的主机名在system

然后

```undefined
我们通过 -o printkey 来看详细内容
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0856ece995f2d09a5375e10870b99d42.png" alt="" style="max-height:209px; box-sizing:content-box;" />


继续跟进

```cobol
--profile=Win7SP1x64 -o 0xfffff8a000024010 printkey -K "ControlSet001"
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/abd48e28292438df00786fe85698a154.png" alt="" style="max-height:189px; box-sizing:content-box;" />




```cobol
--profile=Win7SP1x64 -o 0xfffff8a000024010 printkey -K "ControlSet001\Control"
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/b794c7151fae9e5961ade3c94a34c73e.png" alt="" style="max-height:294px; box-sizing:content-box;" />




```cobol
--profile=Win7SP1x64 -o 0xfffff8a000024010 printkey -K "ControlSet001\Control\ComputerName"
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/7f20f5b3e130e6e3bd9df77e00ba5777.png" alt="" style="max-height:124px; box-sizing:content-box;" />


```cobol
--profile=Win7SP1x64 -o 0xfffff8a000024010 printkey -K "ControlSet001\Control\ComputerName\ComputerName"
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/29ecd490653f77eab836739f6c2e05e1.png" alt="" style="max-height:154px; box-sizing:content-box;" />


到此 主机名就出现了



### 查看剪切板

[OtterCTF 2018]



<img src="https://i-blog.csdnimg.cn/blog_migrate/7c5e563517f8069649718ec792b37899.png" alt="" style="max-height:368px; box-sizing:content-box;" />


题目告诉我们 他复制到在线密码管理的地方了

复制粘贴就需要用到剪切板

我们可以通过vol直接打印剪切板的内容

```cobol
py -2 vol.py -f C:\Users\12455\Desktop\OtterCTF.vmem --profile=Win7SP1x64  clipboard
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/840e16d05b2a2e7a43140d782bd170d5.png" alt="" style="max-height:254px; box-sizing:content-box;" />


答案就出现了

### 查看恶意程序感染

```cobol
py -2 vol.py -f C:\Users\12455\Desktop\OtterCTF.vmem --profile=Win7SP1x64  pstree
```

只需要看树就行了



<img src="https://i-blog.csdnimg.cn/blog_migrate/e450c1274ae58da8b300afdb97b4e81e.png" alt="" style="max-height:61px; box-sizing:content-box;" />


能发现可疑 的瑞克和莫提

然后树下面存在VMware-tray.exe 怀疑就是

去看看有没有执行命令

```cobol
py -2 vol.py -f C:\Users\12455\Desktop\OtterCTF.vmem --profile=Win7SP1x64  cmdline -p  3820,3720
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/c0636271b05831b57d07c8d14cf90d2b.png" alt="" style="max-height:202px; box-sizing:content-box;" />


### 跟踪种子下载的恶意软件

在上面我们发现了恶意软件的的执行

这里我们需要找一下种子中的恶意出现在哪里

就是先去寻找种子文件

先通过 grep 查找相关文件

```cobol
py -2 vol.py -f C:\Users\12455\Desktop\OtterCTF.vmem --profile=Win7SP1x64  filescan | grep "Rick And Morty"
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/f97c3f0c52209c59eda4b9b6c308233a.png" alt="" style="max-height:167px; box-sizing:content-box;" />


然后我们导出

```cobol
py -2 vol.py -f C:\Users\12455\Desktop\OtterCTF.vmem --profile=Win7SP1x64  dumpfiles -Q 0x000000007d63dbc0,0x000000007d8813c0,0x000000007da56240,0x000000007dae9350,0x000000007dcbf6f0,0x000000007e710070 -D C:\Users\12455\Desktop\1
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/765683b1252cd6cc642d5b291501f409.png" alt="" style="max-height:207px; box-sizing:content-box;" />


通过linux的strings 或者 010 查看

最后在查找第四个的时候 发现了

```cobol
py -2 vol.py -f C:\Users\12455\Desktop\OtterCTF.vmem --profile=Win7SP1x64  dumpfiles -Q 0x000000007dae9350 -D C:\Users\12455\Desktop\1
```

特殊的字符



<img src="https://i-blog.csdnimg.cn/blog_migrate/007c532ed81499060ab8c5da33470e6e.png" alt="" style="max-height:136px; box-sizing:content-box;" />




```cobol
M3an_T0rren7_4_R!cke
```

### 继续跟进到浏览器下载种子

要我们继续跟进



种子文件多半就是浏览器下载的

所以我们继续跟进到Chrome浏览器

```cobol
py -2 vol.py -f C:\Users\12455\Desktop\OtterCTF.vmem --profile=Win7SP1x64  pslist | grep chrome
```

通过扫描进程 我们发现了运行过的Chrome浏览器 我们导出进程备份文件

然后通过linux的strings 指定 上下10条 搜索有关rick and morty的内容

```cobol
strings 1808.dmp |grep "Rick And Morty"  -C 10
```

一直尝试下去

直到在 dip为  3924的dmp文件中找到了奇怪的字符



<img src="https://i-blog.csdnimg.cn/blog_migrate/f722b12dccbbd14fd9dbd46fe8d0ed34.png" alt="" style="max-height:224px; box-sizing:content-box;" />




```cobol
Hum@n_I5_Th3_Weak3s7_Link_In_Th3_Ch@inYear
```

### 通过exe转存勒索文件

这里就学会新的插件

通过

```css
procdump  -p pid  -D 
 
可以把文件作为exe导出
```

我们就把恶意软件导出

```cobol
py -2 vol.py -f C:\Users\12455\Desktop\OtterCTF.vmem --profile=Win7SP1x64 procdump -p 3720 -D C:\Users\12455\Desktop\1
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/fae613b2f577afefa96e8f9590230c26.png" alt="" style="max-height:95px; box-sizing:content-box;" />


然后我们可以对这个程序进行分析

通过先查看多少位



<img src="https://i-blog.csdnimg.cn/blog_migrate/9c9a3ed42ea0295188a4485d543422d7.png" alt="" style="max-height:116px; box-sizing:content-box;" />


32位 直接ida打开看看

在date块有一些可疑的 提交看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/0192aa4934bf3da13b179b1f004399d9.png" alt="" style="max-height:268px; box-sizing:content-box;" />


最后发现是这个

### 文件分离得到图片

题目提示我们

恶意软件的图形中有一些可疑之处。

那我们就通过binwalk 分离就可以了



```cobol
binwalk -e executable.3720.exe --run-as=root
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/61f7a0648d6fdbdd190aa4ac711bcf92.png" alt="" style="max-height:166px; box-sizing:content-box;" />


然后就通过png打开即可

但是我无法打开 所以使用另一个 **`foremost 分离`** 

```r
foremost -T executable.3720.exe
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/fdc9a6e18142357005e16ff67afabd4f.png" alt="" style="max-height:746px; box-sizing:content-box;" />


### 让我们找加密文件的密码

ida分析

我们能发现又几个可疑函数



<img src="https://i-blog.csdnimg.cn/blog_migrate/bd6a40f534aab2ae7ad896499f6a58e0.png" alt="" style="max-height:116px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/7e036816f0779d2b48b2fa3feae19612.png" alt="" style="max-height:187px; box-sizing:content-box;" />


里面能发现使用到了 主机名-用户名

那我们直接通过strings  WIN-LO6FAF3DTFE-rick看看内存文件

```cobol
strings  -eb OtterCTF.vmem  |grep WIN-LO6FAF3DTFE-Rick
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/30f36029027355e862897e7676d6dd6f.png" alt="" style="max-height:59px; box-sizing:content-box;" />