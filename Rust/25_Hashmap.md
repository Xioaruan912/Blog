# HashMap

## 创建

```
通过hash函数决定如何存放K和V
```

```rust
use std::collections::HashMap;

fn main(){
    let mut  v = HashMap::new();
    v.insert('s', true);
}
```