# Cargo介绍

构建大项目的时候使用

是rust的构建系统和包管理 

在安装rust的时候自动安装cargo 

我们上面的 rust-analyzer

# Cargo创建项目

```
cargo new hellocargo
就会创建一个文件夹项目
```

```
如果已经有目录了 
那么就使用 cargo init
```

在创建项目后如下

```
src
|_ main.rs
Cargo.toml
```

cargo.toml

```
[package]
name = "coding杂项"  项目名字
version = "0.1.0"   版本
edition = "2024"    时间
 
[dependencies]   依赖项

[[bin]]
name = "coding杂项"
path = "main.rs"

```

在这个配置下 代码都应该严格放在src目录下 

# 快速构建应用程序

cargo build

# 运行cargo

cargo run 编译+ 执行

# 检查代码是否通过

cargo check

可以在编写代码的时候周期性检查 查看是否能通过编译

# 发布

catgo build –release