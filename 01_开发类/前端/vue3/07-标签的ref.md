```vue
<template>
<div class="person">
    <h1>中国</h1>
    <h2 ref="title2">北京</h2>
    <button @click="showLog">点击输出h2</button>
</div>

</template>

<script setup lang="ts">
    import {ref} from "vue"
    let title2  = ref()
        function showLog(){
            console.log(document.getElementById("title2"))
        }
</script>

<style scoped>
    
</style>
```

但是如果其他vue文件也有title2 那么就冲突

这里我们需要注意一个内容 vue3生成的 整个项目中的id需要唯一 所以我们如何可以通过vue3 输出组件中特定标签呢

```vue
<template>
<div class="person">
    <h1>中国</h1>
    <h2 ref="title2">北京</h2> //返回响应式数据
    <button @click="showLog">点击输出h2</button>
</div>

</template>

<script setup lang="ts">
    import {ref} from "vue"
    let title2  = ref()  //为title注册为ref 响应式数据
        function showLog(){
            console.log(title2.value)
        }
</script>

<style scoped>
    
</style>
```

这个`ref标签` 和 id不同 不是全局唯一 而是组件内部唯一 所以不会冲突

并且 如果希望获取组件的信息 那么通过 `deineExpose`

