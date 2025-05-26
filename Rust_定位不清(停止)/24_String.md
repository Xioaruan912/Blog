默认使用UTF-8 编码

rust 原生只提供字符串切片  str

```
let s1 = String::from("value");
let s2 = "abcdefg".to_string();
```

# 拼接字符串

通过 + 号

```
s1 + &s2 // 如果如果引用就可以保留所有权 
format!("{}-{}-{}",s1,s2,s3);  //不取得所有权
```

# 字节 标量值 字形簇

