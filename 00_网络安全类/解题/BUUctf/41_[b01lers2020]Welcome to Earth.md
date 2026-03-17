# [b01lers2020]Welcome to Earth

类似签到题了

一直看js就可以获得最后的混淆

```cobol
// Run to scramble original flag
//console.log(scramble(flag, action));
function scramble(flag, key) {
  for (var i = 0; i < key.length; i++) {
    let n = key.charCodeAt(i) % flag.length;
    let temp = flag[i];
    flag[i] = flag[n];
    flag[n] = temp;
  }
  return flag;
}
 
function check_action() {
  var action = document.getElementById("action").value;
  var flag = ["{hey", "_boy", "aaaa", "s_im", "ck!}", "_baa", "aaaa", "pctf"];
 
  // TODO: unscramble function
}
```

其实猜一下也可以

或者可以利用排列组合的 排列来搞

直接利用py代码

itertools

```cobol
from itertools import permutations
 
flag = ["{hey", "_boy", "aaaa", "s_im", "ck!}", "_baa", "aaaa", "pctf"]
 
item = permutations(flag)
 
for i in item:
    k=''.join(list(i))
    if k.startswith('pctf{')    and k[-1]=='}':
        print(k)
```



<img src="https://i-blog.csdnimg.cn/blog_migrate/1c9f225cbb27da223d7f5eab6aad1dc2.png" alt="" style="max-height:119px; box-sizing:content-box;" />