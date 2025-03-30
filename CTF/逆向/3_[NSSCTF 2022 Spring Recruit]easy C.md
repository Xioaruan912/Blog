# [NSSCTF 2022 Spring Recruit]easy C

直接给出源代码

```cobol
#include <stdio.h>
#include <string.h>
 
int main(){
    char a[]="wwwwwww";
    char b[]="d`vxbQd";
 
    //try to find out the flag
    printf("please input flag:");
    scanf(" %s",&a);
 
    if(strlen(a)!=7){
        printf("NoNoNo\n");
        system("pause");
        return 0;
    }
 
    for(int i=0;i<7;i++){
        a[i]++;
        a[i]=a[i]^2;
    }
 
    if(!strcmp(a,b)){
        printf("good!\n");
        system("pause");
        return 0;
    }
 
    printf("NoNoNo\n");
    system("pause");
    return 0;
    //flag 记得包上 NSSCTF{} 再提交!!!
}
```

能发现 关键是比对a,b然后出flag a为我们输入 b为内定的值 所以我们传入的内容需要结果一系列加密 变为 b

我们逆着写算法即可

```cobol
 
    for(int i=0;i<7;i++){
        a[i]++;
        a[i]=a[i]^2;
    }
 
 
逆向就是
 
python脚本
    
     for i in range(0,7):
        flag += chr((ord(b[i])^2)-1)
    print(flag)
```

EXP

```cobol
a = 'd`vxbQd'
a = list(a)
flag=''
for i in range(0, 7):
    flag += chr((ord(a[i]) ^ 2) - 1)
print(flag)
```