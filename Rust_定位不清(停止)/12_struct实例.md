# struct实例

```rust
struct Area{
    long : u32,
    weight : u32,
    area  : u32,
}

fn main(){
    let mut test1 = Area{
        long:4,
        weight:5,
        area:0,
    };
    test1.area = test1.long * test1.weight;
    println!("长方形面积为 {}", test1.area);
}
```

# 结构体的输出

```
#[derive(Debug)]
//使用调试方法输出 这样就会输出 结构体实例的全部内容
struct Area{
    long : u32,
    weight : u32,
    area  : u32,
}

fn main(){
    let mut test1 = Area{
        long:4,
        weight:5,
        area:0,
    };
    test1.area = test1.long * test1.weight;
    println!("长方形面积为 {}", test1.area);
    //通过特殊格式化输出
    println!("{:?}",test1);
}
```

如果需要更加美化的输出 格式化修改为 {:#?} 即可

```
长方形面积为 20
Area {        
    long: 4,  
    weight: 5,
    area: 20, 
}
```

