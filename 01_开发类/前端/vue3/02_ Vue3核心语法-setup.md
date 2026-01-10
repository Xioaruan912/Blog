# Composition API

这是VUE3 提出的 组合风格API

可以用函数的方式 更优雅的组合代码

# Setup

setup是vue3 的一个配置项

他是一个配置项 所以我们可以在之前通过Vue2写的修改为一个setup

```
<template>
    <div class="person">
    //上面这里数据引入没有变化
        <h2>姓名:{{ name }}</h2>
        <button @click="changeName">修改名字</button>
        <button @click="changeAge">修改年龄</button>
        <h2>年龄:{{ age }}</h2>
        <button @click="showTel">查看联系方式</button>
    </div>
</template>

<script>
export default {
    name : "Person",
    //这里是VUE3了
    setup() {
        //数据
        let name ="张三"
        let age = 12
        let tel =111111
     
        //方法
        function changeName(){
            name = 'zhangsan'
        }
        function changeAge(){
            age = 111
        }
        function showTel(){
            alert(tel)
            
        }
        return {name,age,changeName,changeAge,showTel}
    }
}
</script>
```

但是点击按钮后不会写入前端 因为我们定义变量不是响应式的

但是先不说 所以继续setup

# 自动添加返回

```vue
<script setup>



      //数据
      let name ="张三"
      let age = 12
      let tel =111111

      //方法
      function changeName(){
          name = 'zhangsan'
      }
      function changeAge(){
          age = 111
      }
      function showTel(){
          alert(tel)
      }
</script>
```

直接自动返回

但是我们如果要控制组件名字 需要写两个script标签

```vue
<script>
export default {
        name : "Person234",
}
</script>


<script setup>

    name : "Person";
    //这里是VUE3了
           //数据
        let name ="张三"
        let age = 12
        let tel =111111
        

        //方法
        function changeName(){
            name = 'zhangsan'
        }
        function changeAge(){
            age = 111
        }
        function showTel(){
            alert(tel)
            
        
}
</script>
```

![image-20250527173511328](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250527173511328.png)

我们为了一次性可以写好 我们需要安装一个插件

