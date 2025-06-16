堆栈s1和s2都使用顺序存储，并共享一个存储区域[0，…，maxsize-1]。采用面向堆栈和面向增长的存储方法，设计s1、s2在堆栈内外的操作。

```c
/*
 * @作者: Xioaruan912 xioaruan@gmail.com
 * @最后编辑人员: Xioaruan912 xioaruan@gmail.com
 * @文件作用介绍: 
 * 
 */
#include <stdio.h>

#define MAXSIZE 20
typedef int Elemtype;
typedef struct stack
{
    Elemtype data[MAXSIZE];
    int top1;
    int top2;
}stack;
// 初始化
void init_stack(){
    stack s;
    s.top1 = -1;
    s.top2 = MAXSIZE;
}
//push   int i 用于选择s1还是s2
bool push(stack *s,int i,Elemtype x){
    if((i != 1 && i !=2 )||(s->top2 - s->top1 == 1)){
        return false;
    }
    if(i == 1){s->data[++s->top1] = x;}
    if(i == 2){s->data[--s->top2] = x;}
    return true;
}

Elemtype pop(stack *s,int i){
    if(i != 1 && i !=2 )return false;
    if(i == 1){
        if(i == -1){
            return false;
        }else{
            Elemtype x = s->data[s->top1--];
            return x;
        }
    }
    if(i == 2){
        if(i == MAXSIZE){
            return false;
        }else{
            Elemtype x = s->data[s->top2++];
            return x;
        }
    }
}
```

