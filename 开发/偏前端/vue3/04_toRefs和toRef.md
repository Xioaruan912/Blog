如果我希望解藕对象的变量就通过toRefs

```vue
<template>
<div class="test">
    <h1>{{ person.name }}</h1>
    <button @click="changeName">英文名字</button>
</div>
</template>

<script setup lang="ts">
    import {reactive,toRefs} from "vue"
    let person = reactive({
        name:'张三',
        age : 1
    })
    let {name,age} = toRefs(person)
    //将name和age 变为响应式数据
    function changeName(){
        person.name = "zhang-san"
    }
</script>

<style scoped>
    .test{
     background-color: skyblue;
     box-shadow: 0cap;
    }
</style>
```

