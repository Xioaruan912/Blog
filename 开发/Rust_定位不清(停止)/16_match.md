类似 switch

```rust
enum Coin{
    penny,
    nickelm,
    Dime,
    Quarter,
}
fn value(Ccoin :Coin) -> u8{
    match Ccoin{
        Coin::Dime => 1,
        Coin::Quarter => 5,
        Coin::nickelm => 10,
        Coin::penny => 25,
    }
}

fn main(){
}
```

这里的match比较简单 但是如果需要多行代码+返回

```rsut
enum Coin{
    penny,
    nickelm,
    Dime,
    Quarter,
}
fn value(Ccoin :Coin) -> u8{
    match Ccoin{
        Coin::Dime => {
            println!("hello 1");
            1
        }
        Coin::Quarter => 5,
        Coin::nickelm => 10,
        Coin::penny => 25,
    }
}

fn main(){
}
```

# 绑定值

```rust
#[derive(Debug)]
enum state{
    LD,
    SA,
}
enum Coin{
    penny,
    nickelm,
    Dime,
    Quarter(state),
}
fn value(Ccoin :Coin) -> u8{
    match Ccoin{
        Coin::Dime => {
            println!("hello 1");
            1
        }
        Coin::Quarter(state) => {
            println!("state from {:#?}",state);
            25
        }
        Coin::nickelm => 10,
        Coin::penny => 25,
    }
}

fn main(){
    let c = Coin::Quarter(state::SA);
    println!("{}",value(c));
}
```

# 匹配Option<T>

```rust
fn plus_one(X : Option<i32>) -> Option<i32>{
    match X {
        None => None,
        Some(i) => Some(i+1),
    }
}
```

这里代码的意思是 如果传入的X 是一个none 我们就返回None

如果传入的是i32 那么我们返回 i32 +1 

```rust
fn main(){
    let i = Some(2);
    plus_one(i);
    plus_one(None);

}

fn plus_one(X : Option<i32>) -> Option<i32>{
    match X {
        None => None,
        Some(i) => Some(i+1),
    }
}
```

# 注意

match必须要穷举所有可能性 才可以合法有效

如果很多 就使用 _    

```
_ => {}
```

实现
