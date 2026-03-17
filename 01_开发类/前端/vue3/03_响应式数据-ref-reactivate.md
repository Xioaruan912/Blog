现在我们都是写死的 无法通过后端响应修改 所以引入响应式数据

# 基本类型的响应式数据 Ref

ref和reactive

首先导入ref

```
import {ref} from "vue"
```

如果要响应式就包一下就可以了

html模版中一切不写value

js/ts代码中一切都要加上.value 才可以对响应式数据改变

```
        let name =ref("张三") //变为响应式数据
        let age = ref(12)
        let tel =111111
```

```
        function changeName(){
            name.value = 'hangman' //增加value才可以
        }
        function changeAge(){
            age.value = 111
        }
```

# 对象类型响应数据 reactivate

reactivate 只能定义对象类型的响应式数据

```vue
<script setup name="car1222223">
    let car = {
        brand:'奔驰',
        price:"100w",
    }
    function changePrice(){
        car.price += 10
    }
</script>
```

这里对于非基本的数据类型我们就需要通过reactivate

```vue
<script setup name="car1222223">
    import {reactive} from "vue"
    let car = reactive({
        brand:'奔驰',
        price:100,
    })
    
    function changePrice(){
        car.price += 10
    }
</script>
```

这样就实现了

## 数组输出

首先在setup中定义数组

```
    let game = [
        {id:'asdasdasd01',name:"王者荣耀"},
        {id:'asdasdasd02',name:"原生"},
        {id:'asdasdasd03',name:"VPS"},  
    ]
```

接着在模版中

```
    <li v-for="item in game" :key="id"></li>
```

```
v-for="item in game"  循环获取
```

```
:key="id" 将item的id组作为唯一标识 并且通过 :解释为js
```

整体代码如下

```vue
<template>
    <div class="person">
    <h2>一辆  {{ car.brand }}</h2>
    <h2>价值  {{ car.price }} w</h2>
    <button @click="changePrice">修改汽车价格</button>

    </div>
    <hr></hr>
    <div>
    <H1>汽车信息</H1>
    <li v-for="item in game" :key="item.id">{{ item.name }}</li>
    <button @click="changeOne"> 修改第一个名字</button>
    </div>
</template>


<script setup name="car1222223">
    import {reactive} from "vue"
    let game = reactive([
        {id:'asdasdasd01',name:"王者荣耀"},
        {id:'asdasdasd02',name:"原生"},
        {id:'asdasdasd03',name:"VPS"},  
    ])

    let car = reactive({
        brand:'奔驰',
        price:100,
    })
    function changeOne(){
        game[0].name = "下册"
    }
    function changePrice(){
        car.price += 10
    }
</script>

```

但是ref也可以定义对象

# 对象类型响应式数据 ref

```vue
<template>
    <div class="person">
    <h2>一辆  {{ car.brand }}</h2>
    <h2>价值  {{ car.price }} w</h2>
    <button @click="changePrice">修改汽车价格</button>

    </div>
    <hr></hr>
    <div>
    <H1>汽车信息</H1>
    <li v-for="item in game" :key="item.id">{{ item.name }}</li>
    <button @click="changeOne"> 修改第一个名字</button>
    </div>
</template>


<script setup name="car1222223">
    import {ref} from "vue"
    let game = ref([
        {id:'asdasdasd01',name:"王者荣耀"},
        {id:'asdasdasd02',name:"原生"},
        {id:'asdasdasd03',name:"VPS"},  
    ])
    
    
    
    let car = ref({
        brand:'奔驰',
        price:100,
    })
    console.log(game)
    function changeOne(){
        game.value[0].name = "下册"
    }
    function changePrice(){
        car.value.price += 10
    }
</script>

<style scoped>
    .person {
        background-color: skyblue;
        box-shadow: 0ch;
        border-radius: 10px;
        padding: 20px;
    }
</style>
```

我们可以看看game的对象类型是什么

```
{
    "dep": {
        "version": 0,
        "sc": 0
    },
    "__v_isRef": true,
    "__v_isShallow": false,
    "_rawValue": [
        {
            "id": "asdasdasd01",
            "name": "王者荣耀"
        },
        {
            "id": "asdasdasd02",
            "name": "原生"
        },
        {
            "id": "asdasdasd03",
            "name": "VPS"
        }
    ],
    "_value": [
        {
            "id": "asdasdasd01",
            "name": "王者荣耀"
        },
        {
            "id": "asdasdasd02",
            "name": "原生"
        },
        {
            "id": "asdasdasd03",
            "name": "VPS"
        }
    ]
}
```

只要前面带 我们可以看看 这个 value 所以我们需要对value[0]修改

# ref和reactivate的使用

### reactivate替换对象

reactivate的对象被修改 那么响应式丢失

```vue
    function changecar(){
        car = {brand : "tts",price:"222"}
    }
```

如何解决呢

需要通过 `Object.assign` 实现

```
    let car = reactive({
        brand:'奔驰',
        price:100,
    })
    function changecar(){
        Object.assign(car,{brand : "tts",price:"222"})
    }
```

要么就直接使用ref 的value属性 那么就可以直接修改

![image-20250527181731071](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250527181731071.png)

