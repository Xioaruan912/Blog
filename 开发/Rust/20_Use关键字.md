使用use 引入公共内容

# 绝对路径

```rust

mod back_of_house{
    pub mod hosting{
        pub fn addd_wordlist(){}
    }
}

use crate::back_of_house::hosting;

pub fn eat(){
    hosting::addd_wordlist();
}
```



但是如果是私有的 无法从hosting模块引入函数

# 相对路径

```rust

mod back_of_house{
    pub mod hosting{
        pub fn addd_wordlist(){}
    }
}

use back_of_house::hosting

pub fn eat(){
    hosting::addd_wordlist();
}
```

同python一样 可以通过as 起别名  

```rust
use std::fmt::Result;
use std::io::Result as IoResult;


fn f1 -> Result {}
fn f2 -> IoResult {}

fn main(){}
```

# 使用pub use 导出module

外部代码希望访问就需要使用pub use

```rust
use back_of_house::hosting;

pub fn eat(){
    hosting::addd_wordlist(); //这里默认是私有的
}

```

所以我们需要通过 pub use 导出

# 使用外部包

通过cargo.toml添加包名和版本

使用use引入  

# 使用嵌套路径清理大量路径 

```
use std::fmt
use std::io
可以修改为
use std::{fmt,io}
```

# 通配符

```
use std::io::*; 这样就全部
```

这里需要谨慎使用