# [Zer0pts2020]Can you guess it? basename特性 和preg_match 绕过

直接就可以进入看看源代码



<img src="https://i-blog.csdnimg.cn/blog_migrate/44065b7b04e6c8c823df45689c550136.png" alt="" style="max-height:854px; box-sizing:content-box;" />


原本以为这道题目有两个方法来做 但是 后面发现第二个没有找到漏洞

这里考点主要就是 正则和basename的特性

首先就是正则

现在出现一个知识点

就是

/index.php/config.php 这种路径 访问的还是 index.php

我们可以试试看



<img src="https://i-blog.csdnimg.cn/blog_migrate/ead5a45d3b22ed85ed312064669d4866.png" alt="" style="max-height:217px; box-sizing:content-box;" />


还是在index.php中过滤了 说明访问的还是 index.php

那我们怎么实现嗯

主要是下面这里

```php
if (isset($_GET['source'])) {
  highlight_file(basename($_SERVER['PHP_SELF']));
  exit();
}
```

首先看看 PHP_SELF输出的是什么



<img src="https://i-blog.csdnimg.cn/blog_migrate/856e00a5604561da45a5f6db9264792a.png" alt="" style="max-height:194px; box-sizing:content-box;" />


$_SERVER['PHP_SELF'] 表示当前 php 文件相对于网站根目录的位置地址

如果我们在后面加上 /config.php呢



<img src="https://i-blog.csdnimg.cn/blog_migrate/d75055ceaf4cd812d03f74a1680f499f.png" alt="" style="max-height:160px; box-sizing:content-box;" />


很显然 还是 被过滤了

因为会被正则匹配到

我们现在的突破点在哪里



<img src="https://i-blog.csdnimg.cn/blog_migrate/8dcf260f92b4f083d466b8d47b273a38.png" alt="" style="max-height:101px; box-sizing:content-box;" />


basename会去除掉非ASCII值

例如

```cobol
/config.php/%ab
```

他就会去除掉 %ab 然后就变为了 config.php

但是这个为什么不会被匹配呢 我们去正则测试一下就行了



<img src="https://i-blog.csdnimg.cn/blog_migrate/7a4996991ebacde5369b02e864e93346.png" alt="" style="max-height:347px; box-sizing:content-box;" />


我们能发现 确实绕过了

所以思路就是

```perl
通过 /config.php/%ab 绕过正则
 
 并且 basename 去除了 后面非ascii 值   %ab
 
这样路径就就为了config.php
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/006143cbeae746825f2ed597529ab152.png" alt="" style="max-height:163px; box-sizing:content-box;" />


那么这道题目payload就出现了

```cobol
index.php/config.php/%ab?source=
 
这里首先正则 因为 后面 存在 /%ab 就不会匹配
 
其次 basename 匹配到 %ab非ascii值 
 
然后就会去除 这样就变为了  index.php/config.php/
 
通过 PHP_SELF 就会匹配到 config.php 
 
然后实现高亮
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/d26c9e8928b0ca357a05a89b8e189259.png" alt="" style="max-height:171px; box-sizing:content-box;" />