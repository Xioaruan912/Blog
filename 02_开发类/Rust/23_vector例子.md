如果希望vector存放多个类型数据 那么通过enum即可实现

```rust
enum Spexcall {
    Int(i32),
    Fload(f64),
    Text(String)
}

fn main(){
    let row = vec![
        Spexcall::Int(2),
        Spexcall::Text(String::from("value")),
        Spexcall::Fload(10.12)
    ];

}
```

