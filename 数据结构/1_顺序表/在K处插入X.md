```c
#include <stdio.h>
#define  MAXSIZE 10

typedef int ElemType;

//顺序表结构体
typedef struct Sqlist{
	ElemType data[MAXSIZE];  //初始化数组
	ElemType length;   //当前元素长度
}Sqlist;

// 遍历顺序表
void Get_arg(Sqlist L){  
	for(int i=0 ; i < L.length ; i++){
		printf("L顺序表第%d个元素为%d\n",i,L.data[i]);
	}
}


//在L第k个位置上插入数据X
void InsertSqlist(Sqlist *L, int k, int X){
	if(L->length >= MAXSIZE){
		return;
	}
	if(k < 0 || k > L->length){
		return;
	}
	for(int i = L->length ; i > k; i--){
		L->data[i] = L->data[i-1];
	}
	L->data[k] = X;
	L->length++;
	return;
}
void main(){
	Sqlist L = {{1,2,3,4},4};
	printf("修改之前\n");
	Get_arg(L);
	InsertSqlist(&L,4,100);
	printf("修改之后\n");
	Get_arg(L);
	getchar();
}
```

![image-20250326134936467](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250326134936467.png)

主要问题是 两个错误判断

1. 超过了 MAXSIZE

   无论数组多大 超过了MAXSIZE 看作溢出

2. 超过当前长度 或者 <0 

   我们可以通过图像看看 我们如果在 4处插入 但是我们length 只有3 所以肯定是报错的

   ![image-20250326140120107](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250326140120107.png)



最后我们也应该判断一下for 循环中的长度如何判别

首先我们插入的时候不能直接插入 不然就覆盖了原本在 k位置上的数据 例如k = 2 第2个位置 那么我们应该将位置3的数据向后移动到位置4

![image-20250326140106805](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250326140106805.png)

那么这里的语句就是  i = L.length -------  L.data[i] = L.data[i-1] 逻辑删除2的数据 这里是通过位序

其实目前这个执行完是下面这个样子

![image-20250326140053134](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250326140053134.png)

k = 2 的时候 我们比对 如果 i > k 就继续 否则 结束

![image-20250326140040134](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250326140040134.png)

接下来我们要插入数据并且维护 Length成员 这样我们就实现了插入

上面的版本是位序版本

下面是位置版本

```c
#include <stdio.h>
#define  MAXSIZE 10

typedef int ElemType;

//顺序表结构体
typedef struct Sqlist{
	ElemType data[MAXSIZE];  //初始化数组
	ElemType length;   //当前元素长度
}Sqlist;

// 遍历顺序表
void Get_arg(Sqlist L){  
	for(int i=0 ; i < L.length ; i++){
		printf("L顺序表第%d个元素为%d\n",i,L.data[i]);
	}
}


//在L第k个位置上插入数据X
void InsertSqlist(Sqlist *L, int k, int X){
	k--;  //将位置变化为位序
	if(L->length >= MAXSIZE){
		return;
	}
	if(k < 0 || k > L->length){
		return;
	}
	for(int i = L->length ; i > k; i--){
		L->data[i] = L->data[i-1];
	}
	L->data[k] = X;
	L->length++;
	return;
}
void main(){
	Sqlist L = {{1,2,3,4},4};
	printf("修改之前\n");
	Get_arg(L);
	InsertSqlist(&L,4,100);
	printf("修改之后\n");
	Get_arg(L);
	getchar();
}
```

![image-20250326141218450](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250326141218450.png)