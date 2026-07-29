# [GFCTF 2021]wordy 编写去花IDAPYTHON

首先查壳 发现没有东西

然后放入ida

发现没有main并且软件混乱



<img src="https://i-blog.csdnimg.cn/blog_migrate/4cb0a76217929ef42c0da6c2cbfe6550.png" alt="" style="max-height:487px; box-sizing:content-box;" />


发现这里1144的地方 出错 IDA无法识别数据 报错内容是EBFF机器码

这里看了wp知道是很常见的花指令 所以我们现在开始去花

这里因为我们需要取出 EBFF 下面的地址也都是 EBFF 所以工作量大 使用IDApython脚本即可

```cobol
start = 0x1135
end = 0x3100
 
for i in range(start,end):
    if get_wide_byte(i)==0xEB:
        if get_wide_byte(i+1) == 0xFF:
            patch_byte(i,0x90)
```





<img src="https://i-blog.csdnimg.cn/blog_migrate/0a02ae1c00d6e35653c1db7bfff1bace.png" alt="" style="max-height:677px; box-sizing:content-box;" />


出现了 flag的值

这里也可以使用idapython脚本来获取值



<img src="https://i-blog.csdnimg.cn/blog_migrate/4c581afcfdbc101befb2f38ac0403518.png" alt="" style="max-height:236px; box-sizing:content-box;" />


我们发现 值都是出现在 FFC0后 所以我们可以通过识别 C0然后chr输出

```cobol
start = 0x1135
end = 0x3100
 
for i in range(start,end):
    if get_wide_byte(i)==0xC0:
        print(chr(idaapi.get_byte(i+2)),end='')
 
 
解释一下 get_wide_byte 是读取这个位置的字节
 
idaapi.get_byte 可以获取到这个byte 其实这里换位 get_wide_byte也行
 
这两个的区别是读取的地方不一样 get_wide是从数据库 即 IDA保存的内容
 
idaapi是从 程序中读取 更加底层
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/1ace85f73932d752978cdbdd5417485d.png" alt="" style="max-height:306px; box-sizing:content-box;" />