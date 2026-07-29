# Path

通过路 径找到模块module

```
绝对 Crate root 开始
相对 当前模块 使用 self super
```

```rust
mod  front_of_house{
    mod hosting{
        fn add_to_waitlist(){}
    }
}

fn eat_food(){
    crate::front_of_house::hosting::add_to_waitlist();
    front_of_house::hosting::add_to_waitlist()
}
```

eatfood需要调用 上面的内容 实用绝对路径比较好

# 私有

如果想 函数或者struct设置为 私有 就可以放到模块

```
rust中 默认函数 方法 struct mod 都是私有的
```

子模块中可以使用所有祖先模块

父模块无法调用子模块的私有内容

# pub关键字

标记公共的

```rust
mod  front_of_house{ //这里和eat_food 是同一级别 所以不需要
    pub mod hosting{  //对外暴露
        pub fn add_to_waitlist(){} //对外暴露
    }
}

fn eat_food(){
    crate::front_of_house::hosting::add_to_waitlist();
    front_of_house::hosting::add_to_waitlist()
}
```

# Super

rust访问上一层目录使用 super关键字

```rust
fn serve_order(){}

mod backofhouse{
    fn fix_incorrect(){ //这里对于serve_order 是类似下一级
        cook_order();
        super::serve_order();  //如果要使用上一级 就需要通过super，并且子函数可以调用父模块
    }
    fn cook_order(){}
}
```

#  Pub Struct

可以对部分字段私有部分pub 

```
    pub struct order{
        pub food : String,
        price:u32
    }
```

# Pub enum 

这里如果修改为pub 那么里面的字段默认pub
