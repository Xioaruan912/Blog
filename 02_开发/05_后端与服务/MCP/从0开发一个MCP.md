我就打算开发一个 attack 工具 

首先构建项目

```
uv init attack
cd attack
uv venv
source ./.venv/bin/activate
uv add "mcp[cli]" httpx loguru
uv pip install --quiet setuptools    
```

这里安装完毕后就可以开始开发

```python
from  typing  import Any
import httpx
from mcp.server.fastmcp import FastMCP
import shutil
import asyncio 
from loguru import logger
mcp = FastMCP("web_lol")


class ErrorDeal(Exception):
    def __init__(self, mess:str,result:str|None):
        super().__init__(mess)
        self.result = result  
```

导入包和定义错误

```python
async def use_tool(tool:str,url :str) -> str:
    # result = await check_env(tool=tool)
    if tool == "dirsearch":
        cmd = ['uv','run',tool,"-u",url,"-q"]
        return cmd
    elif tool == "nmap":
        cmd = [tool,url]  
        return cmd

```

构建 shell  原本存在一个 check_env的 但是考虑到 dirsearch 不存在 应用程序 所以不搞了

```python

@mcp.tool(name="information_search",description="对web进行基本信息扫描")
async def information_search(tool:str,url:str) -> str:
    """ 对传入url 使用 进行扫描 返回扫描结果
    args:
        tool:需要使用的工具包含： dirsearch,nmap 
        url: 需要扫描的url 可以是 单个ip
    """
    logger.info("开始检查tool")
    cmd = await use_tool(tool=tool,url=url)
    logger.info("开始执行tool")
    
    proc = await asyncio.create_subprocess_exec(
        *cmd,
        stdout= asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE  
    )
    out,err = await proc.communicate()
    if proc.returncode == 0:
       return  out.decode().strip()
    else:
        raise ErrorDeal("扫描错误"," error run out ")
    
    
```

mcp 开启扫描服务

```
    
if __name__ == "__main__":
    mcp.run(transport="stdio")
```

这样就构建完毕 我们开始调试

```
mcp dev server.py
```

![image-20250514152645432](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250514152645432.png)