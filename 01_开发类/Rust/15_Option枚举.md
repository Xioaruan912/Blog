定义在标准库 

Rust不存在Null 提供类似 Null的 就是 option<T>

其中的T是泛型参数

```rust
fn main(){
    let some_num = Some(5);
    let some_str =  Some("Sting");
    let abc: Option<i32> = None;
}
```

这里的就是 可以防止 Null泛滥

这里Option的内容为

```
some(T)
None
```

这里说明 我存在一个 T类型的 值  并且如果None的话 T这个值无效的