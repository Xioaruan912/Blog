rust包含

```
Package 包 是最顶层的 
Crate 单元包 可以产生一个 libarary和一个可执行
Module 模块 可以通过use 控制
Package -> Crate -> Module
Path 路径
```

# Crate

要么是 library 要么是exe

## Crate root

源代码文件 从这个文件组成Crate

# package

一个Cargo.toml 说明如何构建Crates 并且只能包含一个 library 

多个 exe crates 

但是只要需要一个 crate

```
cargo new package_Name
```

构建一个自己的package

```
src/main.rs
```

 这里默认是一个 binary crate的 crate root

```
src/lib.rs
```

这里默认是一个 library crate 的 crate root

这里两个分别搭建。library或者 binary crate

```
src/bin 目录下存放不同的 binary crate
```

# Crate的作用

可以类似python的函数

# 定义module

在一个crate中 把代码分组 增加可读性和复用性

```
mod 关键字
```

并且可以嵌套

```rust
mod  front_of_house{
    mod hosting{
        fn add_to_waitlist(){}
        fn sear_at() {}
    }

    mod serving {
        fn takeorder(){}
        fn server_order(){}
        fn take_payment(){}
    }
}
```

![image-20250518205701354](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250518205701354.png)