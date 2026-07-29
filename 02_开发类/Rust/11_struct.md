# 构建结构体

```rust

struct User{
        username:String,
        email:String,
        age:u32,
        enable:bool,
    }
fn main(){
    //实例化
    let users = User{
        age:1,
        username:String::from("Xioa"),
        email:String::from("xiaoruan@abcd.com"),
        enable:true,
    };
}
```

并且在声明的时候 必须要对所有的值赋值 否则报错

# 访问字段

```rust

struct User{
        username:String,
        email:String,
        age:u32,
        enable:bool,
    }
fn main(){
    //实例化
    let mut users = User{
        age:1,
        username:String::from("Xioa"),
        email:String::from("xiaoruan@abcd.com"),
        enable:true,
    };
    users.email = String::from("New")
}
```

并且如果可变 那么全部需要可变

# 基于现有的创建新Struct

```rust

struct User{
        username:String,
        email:String,
        age:u32,
        enable:bool,
    }
fn main(){
    //实例化
    let mut users = User{
        age:1,
        username:String::from("Xioa"),
        email:String::from("xiaoruan@abcd.com"),
        enable:true,
    };
    users.email = String::from("New");
    //通过更新语法 user2 可以 基于user1的enable和age 不用重复编写
    let mut user2 = User{
        username:String::from("test"),
        email:String::from("test@abcd.com"),
        ..users
    }
} 
```

这里很简单可以发现通过

```
..users
```

和

```
enable:users.enable,
age:users.age,
```

操作一致

# Tuple Struct

定义类似 tuple的struct

适用于 给tuple起名字 不同于其他tuple 但是不要对每个元素起名字

```rust
struct Color(i32,i32,i32);
struct Point(i32,i32,i32);

fn main(){
    let black = Color(0,0,0);
    let origin = Point(0,0,0);
}
```

# Unit-Like Struct

没有任何字段的 struct 和 （） 类似

# 所有权

```
struct User{
        username:String,
        email:String,
        age:u32,
        enable:bool,
    }
```

这个 只要User是有效的 那么里面的字段也是有效

如果Struct 里面存放的是 & 引用

那么需要使用生命周期保证 Struct有效 引用依旧有效

如果不使用 就会报错