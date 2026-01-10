# DOS MZ头

## _IMAGE_DOS_HEADER

```c
typedef struct _IMAGE_DOS_HEADER {      // DOS .EXE header
    WORD   e_magic;                     // Magic number
    WORD   e_cblp;                      // Bytes on last page of file
    WORD   e_cp;                        // Pages in file
    WORD   e_crlc;                      // Relocations
    WORD   e_cparhdr;                   // Size of header in paragraphs
    WORD   e_minalloc;                  // Minimum extra paragraphs needed
    WORD   e_maxalloc;                  // Maximum extra paragraphs needed
    WORD   e_ss;                        // Initial (relative) SS value
    WORD   e_sp;                        // Initial SP value
    WORD   e_csum;                      // Checksum
    WORD   e_ip;                        // Initial IP value
    WORD   e_cs;                        // Initial (relative) CS value
    WORD   e_lfarlc;                    // File address of relocation table
    WORD   e_ovno;                      // Overlay number
    WORD   e_res[4];                    // Reserved words
    WORD   e_oemid;                     // OEM identifier (for e_oeminfo)
    WORD   e_oeminfo;                   // OEM information; e_oemid specific
    WORD   e_res2[10];                  // Reserved words
    LONG   e_lfanew;                    // File address of new exe header
  } IMAGE_DOS_HEADER, *PIMAGE_DOS_HEADER;

```

dos mz头是给 16位程序使用 目前已经接近淘汰

所以我们主要学习的内容是

```
typedef struct _IMAGE_DOS_HEADER {      // DOS .EXE header
    WORD   e_magic;                     // Magic number
    LONG   e_lfanew;                    // File address of new exe header
  } IMAGE_DOS_HEADER, *PIMAGE_DOS_HEADER;

```

这里我们可以做个测试 dos mz头64位  我们就保留 第一个字和最后一个long 看看能不能运行  

![image-20250319141832295](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250319141832295.png)

这里我们将其他内容全部填充0	

![image-20250319141849764](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250319141849764.png)、

保存后依旧可以正常执行文件 所以我们只需要了解到这里即可 因为其他内容 已经随着历史淘汰了



## DOS_STUB

这里数据也无用 可以全填充0

# 总结

除了 `IMAGE_DOS_HHEADER` 中的 

```
    WORD   e_magic;                     // Magic number
    LONG   e_lfanew;                    // File address of new exe header
```

其余的 第一部分 DOS部分内容 全部可以修改 已经不符合现代计算机用法了
