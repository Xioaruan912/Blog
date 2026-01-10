<?php
//hint: flag 在根目录下，名字是一个根目录下不常见的文件名
error_reporting(0);
show_source(__FILE__);
$a = $_POST['a'];
$b = '(~SHIP}:{TAF$)';
if (strspn($a, $b) !== strlen($a)) {
   die('hacker!!!');
}
system("$a");
?>