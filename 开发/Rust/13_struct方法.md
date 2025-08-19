# struct的方法

与函数类似 但是不同

只能在 struct 上下文定义

第一个参数为 self

```rust
#[derive(Debug)]
struct Area{
    long : u32,
    weight : u32,
}
//声明 Area的方法
impl Area {
    //定义方法 self可以被认为 Area这个结构体
    fn area(&self) -> u32{
        self.long  * self.weight
    }
}

fn main(){
    let rect = Area{
        long : 10,
        weight : 20
    };
    //直接调用
    println!("{}",rect.area())
}
```

```
需要在 impl中 定义
第一个参数一定是 &self 或者 &mut self
这样就可以有更好的代码结构
```

```
方法调用的运算符 和c差不多
```

```rust

struct Area{
    long : u32,
    weight : u32,
}
impl Area {
    // fn area(&self) -> u32{
    //     self.long  * self.weight
    // }
    fn insize(&self, other : &Area) -> bool{
        self.long > other.long && self.weight > other.weight
    }
}

fn main(){
    let rect = Area{
        long : 10,
        weight : 20
    };
    let rect2 = Area{
        long : 20,
        weight : 30
    };
    println!("{}",rect.insize(&rect2))
}
```

方法也可以加上别的参数

# 关联函数

不是方法 并且不把self作为第一个

例如

```
String::from
```

from 就是关联函数

```rust
#[derive(Debug)]
struct Area{
    long : u32,
    weight : u32,
}
impl Area {

    //实现关联函数
    fn square(size:u32) -> Area{
        Area { 
            long: size, 
            weight:size  
        }
    }
}

fn main(){
    let s = Area::square(5);
    println!("{:#?}",s)
}
```

可以这样说明 就是函数在 Area的命名空间中



上面的不同方法 可以放在不同的 impl中 但是其实没有必要