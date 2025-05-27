# 监视数据变化

能监视4种内容

![image-20250527195036226](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250527195036226.png)

# 情况一 ref监视基本类型

监视ref的基本类型

```
import {ref,watch} from "vue"
```

```vue
<script setup lang="ts">
    import {ref,watch} from "vue"
    let sum = ref(0)

    function sumAdd(){
        sum.value += 1
    }

    //监视
    watch(sum,(newvalue,oldvalue) => {
        console.log("sm变化",newvalue,oldvalue)
    })
</script>
```

watch调用时候会有一个返回值 就是停止函数

```vue
const stopWatch  =     watch(sum,(newvalue,oldvalue) => {
        console.log("sm变化",newvalue,oldvalue)
    })
```

一个地方想停止直接调用即可

# 情况二 ref监视对象类型

```
    watch(person,(newValue,oldValue) => {
        console.log("修改了",oldValue,newValue)
    })
```

这个方式的监视 是监视整个属性

如果整个属性通过

```
person.value = {name:"lisi",age:1111}
```

修改 那么触发

如果要监视里面的属性 需要开启深度监视

```
    watch(person,(newValue,oldValue) => {
        console.log("修改了",oldValue,newValue)
    },{ deep:true})
```

这样里面的元素改变就会触发

# 情况三  reactivate监视对象类型

```
    watch(car,(newValue,oldValue) => {
        console.log("修改了",oldValue,newValue)
    },{ deep:true,
    })
```

这样和ref一样 三个都可以发啥改变

```
    watch(car,(newValue,oldValue) => {
        console.log("修改了",oldValue,newValue)
    })
```

但是其实这样也是 可以触发所有监视 默认开启深度监视

# 情况四 监视ref和reactivate的对象的某个属性

监视基本类型的属性 需要加工属性为getter其实就是 函数返回这种类型

```
    watch(()=>{return cat.brand},(newValue,oldValue) => {
        console.log("修改了",oldValue,newValue)
    })
```

只需要将返回内容修改为某个属性 就可以实现监控

# 情况五  监控多个数据

```
    watch([()=>cow.age,()=>cow.brand],(newValue,oldValue) => {
        console.log("修改了",oldValue,newValue)
    })
```

# 完整代码如下

```vue
<template>
<div class="test">
    <h1>情况一： 【ref】 监视 【基本类型】</h1>
    <h1> {{ sum }}</h1>
    <button @click="sumAdd">点击sum + 1 </button>
</div>
<div class="test_2">
    <h1>情况二： 【ref】 监视 【对象类型】</h1>
    <h1> 姓名 ： {{ person.name }}</h1>
    <h1> 年龄 ： {{ person.age}}</h1>
    
    <button @click="changeName">修改名字 </button>
    <button @click="changeAge">修改年龄 </button>
    <button @click="changePerson">修改Person </button>
</div>
<div class="test_3">
    <h1>情况三： 【reactive】 监视 【对象类型】</h1>
    <h1> 车辆信息 ： {{ car.brand }}</h1>
    <h1> 车龄 ： {{ car.age}}</h1>
    
    <button @click="changecarName">修改汽车品牌 </button>
    <button @click="changecarAge">修改汽车年龄 </button>
    <button @click="changeCar">修改Car </button>
</div>

<div class="test_4">
    <h1>情况四： 【ref】【reactive】 监视 【对象类型的某个属性】</h1>
    <h1> 猫品种 ： {{ cat.brand }}</h1>
    <h1> 年龄 ： {{ cat.age}}</h1>
    
    <button @click="changecatName">修改猫品牌 </button>
    <button @click="changecatAge">修改猫年龄 </button>
    <button @click="changeCat">修改Cat </button>
</div>

<div class="test_5">
    <h1>情况五： 【ref】【reactive】 监视 【多个数据】</h1>
    <h1> 牛品种 ： {{ cow.brand }}</h1>
    <h1> 幸存 ： {{ cow.alive }}</h1>
    <h1> 年龄 ： {{ cow.age}}</h1>
    
    <button @click="changecowName">修改牛品牌 </button>
    <button @click="changecowAge">修改牛年龄 </button>
    <button @click="changecowAlive">修改是否存在 </button>
    <button @click="changeCow">修改Cow </button>
</div>
</template>

<script setup lang="ts">
    import {ref,watch,reactive} from "vue"
    //====================================== 情况一
    let sum = ref(0)

    function sumAdd(){
        sum.value += 1
    }

    //监视
    watch(sum,(newvalue,oldvalue) => {
        console.log("sm变化",newvalue,oldvalue)
    })
    //=================================== 情况二
    let person =ref({
        name:"张三",
        age : 18
    })
    function changeName(){
        person.value.name = "zhan-san"
    }    
    function changeAge(){
        person.value.age = 111111
    }
    function changePerson(){
        person.value = {name:"lisi",age:1111}
    }

    watch(person,(newValue,oldValue) => {
        console.log("修改了",oldValue,newValue)
    },{ deep:true,
    })
    //================================ 情况三
    let car =reactive({
        brand:"奔驰",
        age : 2
    })
    function changecarName(){
        car.brand = "宝马"
    }    
    function changecarAge(){
        car.age= 111111
    }
    function changeCar(){
        car= Object.assign(car, {brand:"本田",age:11})
    }

    watch(car,(newValue,oldValue) => {
        console.log("修改了",oldValue,newValue)
    })

    //==================================  情况四
    let cat =reactive({
        brand:"白猫",
        age : 2
    })
    function changecatName(){
        cat.brand  = "橘猫"
    }    
    function changecatAge(){
        cat.age= 111111
    }
    function changeCat(){
        cat= Object.assign(car, {brand:"黑猫",age:11})
    }

    watch(()=>{return cat.brand},(newValue,oldValue) => {
        console.log("修改了",oldValue,newValue)
    })
    //==================================  情况五
        let cow =reactive({
        brand:"黑牛",
        age : 2,
        alive:true
    })
    function changecowName(){
        cow.brand  = "白牛"
    }    
    function changecowAge(){
        cow.age= 111111
    }
    function changecowAlive(){
        cow.alive = false
    }
    function changeCow(){
        cow= Object.assign(cow, {brand:"疯牛",age:11,alive:false})
    }

    watch([()=>cow.age,()=>cow.brand],(newValue,oldValue) => {
        console.log("修改了",oldValue,newValue)
    })
</script>

<style scoped>
    .test{
        background-color: skyblue;
        text-shadow: 10px;
    }
    .test_2{
        background-color: rebeccapurple;
        text-shadow: 10px;
    }    
    .test_3{
        background-color: rgb(187, 8, 20);
        text-shadow: 10px;
    }
    .test_4{
        background-color: rgb(1, 185, 50);
        text-shadow: 10px;
    }   
     .test_5{
        background-color: rgb(187, 255, 0);
        text-shadow: 10px;
    }
</style>
```

# 实战

```vue
<template>
<div class="test">
    <h1>需求 : 当水温60 或者 水位 80时 方式给服务器</h1>
    <h1> 水温 {{ temp }} 摄氏度</h1>
    <h1> 水位 {{ height }} cm</h1>
    <button @click="tempAdd">水温 + 10 </button>
    <button @click="HeightAdd">水位 + 10 </button>
</div>
</template>

<script setup lang="ts">
    import {ref,watch,reactive} from "vue"
    //====================================== 情况一
    let temp = ref(0)
    let height = ref(0)
    function tempAdd(){
        temp.value += 10
    }
    function HeightAdd(){
        height.value += 10
    }
    //监视
    watch([()=>temp.value,()=>height.value],(newvalue,oldvalue) => {
        if(newvalue[0] >= 60 || newvalue[1] >= 80){
          //这里可以使用结构赋值
          //let [newtmp,newheight] = newvalue
            console.log("达到预设值")
        }
    })  
</script>

<style scoped>
    .test{
        background-color: skyblue;
        text-shadow: 10px;
    }

</style>
```

 从上面实战可以发现 我如果监视数据多了 那么watch很麻烦

# watchEffect 【推荐】

```vue
<template>
<div class="test">
    <h1>需求 : 当水温60 或者 水位 80时 方式给服务器</h1>
    <h1> 水温 {{ temp }} 摄氏度</h1>
    <h1> 水位 {{ height }} cm</h1>
    <button @click="tempAdd">水温 + 10 </button>
    <button @click="HeightAdd">水位 + 10 </button>
</div>
</template>

<script setup lang="ts">
    import {ref,watchEffect,reactive} from "vue"
    //====================================== 情况一
    let temp = ref(0)
    let height = ref(0)
    function tempAdd(){
        temp.value += 10
    }
    function HeightAdd(){
        height.value += 10
    }
    //监视
    watchEffect(() => {    
        if(temp.value >= 60 || height.value >= 80){
            console.log("发送服务器")
        }
    })  
</script>

<style scoped>
    .test{
        background-color: skyblue;
        text-shadow: 10px;
    }

</style>
```

实际开发 使用 watchEffect 更加好 更加智能