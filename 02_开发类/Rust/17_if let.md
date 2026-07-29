if let 只关心一种匹配

```
fn main(){
    let v = Some(0u8);
    match v{
        Some(3) => println!("3"),
        Some(2) => println!("2"),
        _ => {},
    }
}
```

 这里我们还需要通过 _ => {} 匹配 如果我们只想匹配 Some(3) 就可以直接使用 if let 

```rust
fn main(){
    let v = Some(0u8);
    match v{
        Some(3) => println!("3"),
        _ => {},
    }

    if let Some(3)  =  v {
        println!("3")
    }
}
```

这里 match和if let 功能是一样的 这里使用什么 就需要通过应用场景实现

# 搭配else

```rust
fn main(){
    let v = Some(0u8);
    match v{
        Some(3) => println!("3"),
        _ => println!("other"),
    }

    if let Some(3)  =  v {
        println!("3")
    }else{
        println!("other")
    }
}
```

