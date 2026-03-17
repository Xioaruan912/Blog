MCP协议是模型协议 支持模型调用本地工具 

内涵tool 其实本质上就是一个函数

MCP服务没有规定如何和模型进行交互 而是规定了 本地的MCP服务和MCP HOST

也就是 Cline cursor 这类软件的交互



![image-20250514101733699](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250514101733699.png)

# 配置MCP服务

使用Vsocde Cline配置

首先去插件市场下载 Cline

![image-20250514090851172](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250514090851172.png)

打开Cline配置

![image-20250514090904275](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250514090904275.png)

配置模型

然后检查 打开 MCP服务设置

![image-20250514090937154](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250514090937154.png)

打开 JSON配置文件 Cline 就是通过json文件去读取 MCP服务

![image-20250514090958911](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250514090958911.png)

我们可以来阅读ida pro的配置文件

![image-20250514091041679](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250514091041679.png)

```
github.com/mrexodia/ida-pro-mcp
```

告诉大模型MCP服务的名字是什么

```
"autoApprove": [
        "check_connection",
        "get_metadata",
        "get_function_by_name",
        "get_function_by_address",
        "get_current_address",
        "get_current_function",
        "convert_number",
        "list_functions",
        "list_globals",
        "list_strings",
        "decompile_function",
        "disassemble_function",
        "get_xrefs_to",
        "get_entry_points",
        "set_comment",
        "rename_local_variable",
        "rename_global_variable",
```

这里是自动Approve的工具 也就是函数 就是大模型调用的函数

```
      "disabled": false,  是否被禁用
      "timeout": 1800,		超时多久视为失败
      "command": "/opt/anaconda3/envs/st/bin/python",  命令是什么
      "args": [
        "/opt/homebrew/lib/python3.11/site-packages/ida_pro_mcp/server.py"    服务代码在哪里
      ],
      "transportType": "stdio"     使用标准输入输出流进行问答
    },
```

这里其实不应该使用python启动 而是使用新一代python管理包工具 UV使用

# UV

这是通过Rust写的 python包管理器 用于代替 pip

```
  curl -LsSf https://astral.sh/uv/install.sh | sh
```

![image-20250514091406703](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250514091406703.png)

## python版本管理

```
uv python list
uv python install 3.11 3.10
uv python uninstall 3.11
uv python find 3.11
uv run --python 3.12 test.py
uv python pin 3.11  固定3.11 到当前项目
```

## 运行脚本

```
uv run test.py
uv run test.py 参数 如果python带参数
uv run --with rich test.py 带依赖运行
```

## 项目管理

```
uv init hello-word
uv add 添加依赖
uv remove 删除
uv tree 查看依赖
uv sync 同步依赖
```

现在 UV 的基本使用结束了

# 第一个MCP server

首先构建一个基本项目 

```
 uv init test_mcp
 cd  test_mcp
 uv venv  配置当前项目的虚拟环境
 source .venv/bin/activate
 uv add mcp[cli] httpx  添加依赖
```

构建 weather.py代码

```python
'''
作者: Xioaruan912 xioaruan@gmail.com
最后编辑人员: Xioaruan912 xioaruan@gmail.com
文件作用介绍: 
'''
from  mcp.server.fastmcp  import FastMCP
import httpx
from typing import Any


#快速构建MCPserver
mcp = FastMCP("weather",log_level = "ERROR")

NWS_API_BASE= "https://api.weather.gov"
User_Agent = "weather-app/1.o"

# 构建请求函数
async def make_nws_req(url : str ) -> dict[str,Any] | None:
    header = {
        "User-Agent": User_Agent,
        "Accept" : "application/geo+json"
        }
    async with httpx.AsyncClient() as client:
        try:
            response =  await client.get(url,headers=header,timeout = 30.0)
            response.raise_for_status()
            return response.json()
        except Exception:
            return None
#构建工具
def format_alert(feature: dict) -> str:

    props = feature["properties"]
    return f"""
Event: {props.get('event', 'Unknown')}
Area: {props.get('areaDesc', 'Unknown')}
Severity: {props.get('severity', 'Unknown')}
Description: {props.get('description', 'No description available')}
Instructions: {props.get('instruction', 'No specific instructions provided')}
"""


# 构建第一个tool
@mcp.tool()
async def get_alerts(state:str) -> str:
    """获取美国天气州
    
    Args:
    state ： 州的名称
    """
    #获取天气预报办公室
    url = f"{NWS_API_BASE}/alerts/active/area/{state}"
    data = await make_nws_req(url=url)
    if not data or "features" not in data:  #检查调用是否成功
        return "Unable to fetch alerts or no alerts found."

    if not data["features"]:        #检查数据是否存在
        return "No active alerts for this state."

    alerts = [format_alert(feature) for feature in data["features"]]   #格式化
    return "\n---\n".join(alerts)

#第二个tool 会通过下面 的 “”“”“” 中获取 mcp的描述传递给大模型
@mcp.tool()
async def get_forecast(latitude:float , longitude : float ) -> str:
    """获取美国天气 
    
    Args:
        latitude : 精度
        longitude : 纬度
    """
    #获取天气预报办公室
    points_url = f"{NWS_API_BASE}/points/{latitude},{longitude}"
    points_data = await make_nws_req(points_url)
    if not points_data:
        return "Unable to fetch forecast data for this location."
    #增加 data 传递
    forecast_url = points_data["properties"]["forecast"]
    forecast_data = await make_nws_req(forecast_url)
    if not forecast_data:
        return "Unable to fetch detailed forecast."

    # Format the periods into a readable forecast
    periods = forecast_data["properties"]["periods"]
    forecasts = []
    for period in periods[:5]:  # Only show next 5 periods
        forecast = f"""
{period['name']}:
Temperature: {period['temperature']}°{period['temperatureUnit']}
Wind: {period['windSpeed']} {period['windDirection']}
Forecast: {period['detailedForecast']}
"""
        forecasts.append(forecast)

    return "\n---\n".join(forecasts)


if __name__ == "__main__":
    mcp.run(transport="stdio") #启动mcp server
    #使用  输入 输出

```

去Cline中注册 MCP服务

```json
    "weather": {
      "disabled": false,
      "timeout": 1800,
      "command": "uv",
      "args": [
        "--directory",
        "/Users/xioaruan/Desktop/test/test_mcp/test_mcp",
        "run",
        "weather.py"
      ],
      "transportType": "stdio"
    }
  }
```

这样就实现了

![image-20250514100205836](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250514100205836.png)

# 抓包分析

```python
#!/usr/bin/env python3

import sys
import subprocess
import threading
import argparse
import os

# --- Configuration ---
LOG_FILE = os.path.join(os.path.dirname(os.path.realpath(__file__)), "mcp_io.json")
# --- End Configuration ---

# --- Argument Parsing ---
parser = argparse.ArgumentParser(
    description="Wrap a command, passing STDIN/STDOUT verbatim while logging them.",
    usage="%(prog)s <command> [args...]"
)
# Capture the command and all subsequent arguments
parser.add_argument('command', nargs=argparse.REMAINDER,
                    help='The command and its arguments to execute.')

open(LOG_FILE, 'w', encoding='utf-8')

if len(sys.argv) == 1:
    parser.print_help(sys.stderr)
    sys.exit(1)

args = parser.parse_args()

if not args.command:
    print("Error: No command provided.", file=sys.stderr)
    parser.print_help(sys.stderr)
    sys.exit(1)

target_command = args.command
# --- End Argument Parsing ---

# --- I/O Forwarding Functions ---
# These will run in separate threads

def forward_and_log_stdin(proxy_stdin, target_stdin, log_file):
    """Reads from proxy's stdin, logs it, writes to target's stdin."""
    try:
        while True:
            # Read line by line from the script's actual stdin
            line_bytes = proxy_stdin.readline()
            if not line_bytes:  # EOF reached
                break

            # Decode for logging (assuming UTF-8, adjust if needed)
            try:
                 line_str = line_bytes.decode('utf-8')
            except UnicodeDecodeError:
                 line_str = f"[Non-UTF8 data, {len(line_bytes)} bytes]\n" # Log representation

            # Log with prefix
            log_file.write(f"输入: {line_str}")
            log_file.flush() # Ensure log is written promptly

            # Write the original bytes to the target process's stdin
            target_stdin.write(line_bytes)
            target_stdin.flush() # Ensure target receives it promptly

    except Exception as e:
        # Log errors happening during forwarding
        try:
            log_file.write(f"!!! STDIN Forwarding Error: {e}\n")
            log_file.flush()
        except: pass # Avoid errors trying to log errors if log file is broken

    finally:
        # Important: Close the target's stdin when proxy's stdin closes
        # This signals EOF to the target process (like test.sh's read loop)
        try:
            target_stdin.close()
            log_file.write("--- STDIN stream closed to target ---\n")
            log_file.flush()
        except Exception as e:
             try:
                log_file.write(f"!!! Error closing target STDIN: {e}\n")
                log_file.flush()
             except: pass


def forward_and_log_stdout(target_stdout, proxy_stdout, log_file):
    """Reads from target's stdout, logs it, writes to proxy's stdout."""
    try:
        while True:
            # Read line by line from the target process's stdout
            line_bytes = target_stdout.readline()
            if not line_bytes: # EOF reached (process exited or closed stdout)
                break

            # Decode for logging
            try:
                 line_str = line_bytes.decode('utf-8')
            except UnicodeDecodeError:
                 line_str = f"[Non-UTF8 data, {len(line_bytes)} bytes]\n"

            # Log with prefix
            log_file.write(f"输出: {line_str}")
            log_file.flush()

            # Write the original bytes to the script's actual stdout
            proxy_stdout.write(line_bytes)
            proxy_stdout.flush() # Ensure output is seen promptly

    except Exception as e:
        try:
            log_file.write(f"!!! STDOUT Forwarding Error: {e}\n")
            log_file.flush()
        except: pass
    finally:
        try:
            log_file.flush()
        except: pass
        # Don't close proxy_stdout (sys.stdout) here

# --- Main Execution ---
process = None
log_f = None
exit_code = 1 # Default exit code in case of early failure

try:
    # Open log file in append mode ('a') for the threads
    log_f = open(LOG_FILE, 'a', encoding='utf-8')

    # Start the target process
    # We use pipes for stdin/stdout
    # We work with bytes (bufsize=0 for unbuffered binary, readline() still works)
    # stderr=subprocess.PIPE could be added to capture stderr too if needed.
    process = subprocess.Popen(
        target_command,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE, # Capture stderr too, good practice
        bufsize=0 # Use 0 for unbuffered binary I/O
    )

    # Pass binary streams to threads
    stdin_thread = threading.Thread(
        target=forward_and_log_stdin,
        args=(sys.stdin.buffer, process.stdin, log_f),
        daemon=True # Allows main thread to exit even if this is stuck (e.g., waiting on stdin) - reconsider if explicit join is needed
    )

    stdout_thread = threading.Thread(
        target=forward_and_log_stdout,
        args=(process.stdout, sys.stdout.buffer, log_f),
        daemon=True
    )

    # Optional: Handle stderr similarly (log and pass through)
    stderr_thread = threading.Thread(
        target=forward_and_log_stdout, # Can reuse the function
        args=(process.stderr, sys.stderr.buffer, log_f), # Pass stderr streams
        # Add a different prefix in the function if needed, or modify function
        # For now, it will log with "STDOUT:" prefix - might want to change function
        # Let's modify the function slightly for this
        daemon=True
    )
    # A slightly modified version for stderr logging
    def forward_and_log_stderr(target_stderr, proxy_stderr, log_file):
        """Reads from target's stderr, logs it, writes to proxy's stderr."""
        try:
            while True:
                line_bytes = target_stderr.readline()
                if not line_bytes: break
                try: line_str = line_bytes.decode('utf-8')
                except UnicodeDecodeError: line_str = f"[Non-UTF8 data, {len(line_bytes)} bytes]\n"
                log_file.write(f"STDERR: {line_str}") # Use STDERR prefix
                log_file.flush()
                proxy_stderr.write(line_bytes)
                proxy_stderr.flush()
        except Exception as e:
            try:
                log_file.write(f"!!! STDERR Forwarding Error: {e}\n")
                log_file.flush()
            except: pass
        finally:
            try:
                log_file.flush()
            except: pass

    stderr_thread = threading.Thread(
        target=forward_and_log_stderr,
        args=(process.stderr, sys.stderr.buffer, log_f),
        daemon=True
    )


    # Start the forwarding threads
    stdin_thread.start()
    stdout_thread.start()
    stderr_thread.start() # Start stderr thread too

    # Wait for the target process to complete
    process.wait()
    exit_code = process.returncode

    # Wait briefly for I/O threads to finish flushing last messages
    # Since they are daemons, they might exit abruptly with the main thread.
    # Joining them ensures cleaner shutdown and logging.
    # We need to make sure the pipes are closed so the reads terminate.
    # process.wait() ensures target process is dead, pipes should close naturally.
    stdin_thread.join(timeout=1.0) # Add timeout in case thread hangs
    stdout_thread.join(timeout=1.0)
    stderr_thread.join(timeout=1.0)


except Exception as e:
    print(f"MCP Logger Error: {e}", file=sys.stderr)
    # Try to log the error too
    if log_f and not log_f.closed:
        try:
            log_f.write(f"!!! MCP Logger Main Error: {e}\n")
            log_f.flush()
        except: pass # Ignore errors during final logging attempt
    exit_code = 1 # Indicate logger failure

finally:
    # Ensure the process is terminated if it's still running (e.g., if logger crashed)
    if process and process.poll() is None:
        try:
            process.terminate()
            process.wait(timeout=1.0) # Give it a moment to terminate
        except: pass # Ignore errors during cleanup
        if process.poll() is None: # Still running?
             try: process.kill() # Force kill
             except: pass # Ignore kill errors

    # Final log message
    if log_f and not log_f.closed:
        try:
            log_f.close()
        except: pass # Ignore errors during final logging attempt

    # Exit with the target process's exit code
    sys.exit(exit_code)

```

配置vscode

```json
    "weather": {
      "disabled": false,
      "timeout": 1800,
      "command": "/opt/anaconda3/envs/st/bin/python",
      "args": [
        "/Users/xioaruan/Desktop/test/test_mcp/test_mcp/mcp_logger.py",
        "uv",
        "--directory",
        "/Users/xioaruan/Desktop/test/test_mcp/test_mcp",
        "run",
        "weather.py"
      ],
      "transportType": "stdio"
    }
```

我们就可以开始看交互了

输入 为 Cline -> MCP

输出为 MCP -> Cline

```json
输入: {
    "method": "initialize",
    "params": {
        "protocolVersion": "2024-11-05", MCP协议最后更新规范
        "capabilities": {},
        "clientInfo": {
            "name": "Cline",  介绍host
            "version": "3.15.3" 版本
        }
    },
    "jsonrpc": "2.0",
    "id": 0
}
```

```json
输出: { 本地MCP告诉Cline
    "jsonrpc": "2.0",
    "id": 0,
    "result": {
        "protocolVersion": "2024-11-05",  协议规范
        "capabilities": {
            "experimental": {},
            "prompts": {
                "listChanged": false
            },
            "resources": {
                "subscribe": false,
                "listChanged": false
            },
            "tools": {
                "listChanged": false
            }
        },
        "serverInfo": {
            "name": "weather",   MCP服务叫什么
            "version": "1.8.1"   版本多少
        }
    }
}
```

```json
输入: {
    "method": "notifications/initialized",  返回确定
    "jsonrpc": "2.0"
}
输入: {
    "method": "tools/list",  要求返回tool的列表
    "jsonrpc": "2.0",
    "id": 1
}
```

```json
输出: {
    "jsonrpc": "2.0",
    "id": 1,
    "result": {
        "tools": [
            {
                "name": "get_alerts",
                "description": "获取美国天气州\n    \n    Args:\n    state ： 州的名称\n    ",
                "inputSchema": {
                    "properties": {
                        "state": {
                            "title": "State",
                            "type": "string"
                        }
                    },
                    "required": [
                        "state"
                    ],
                    "title": "get_alertsArguments",
                    "type": "object"
                }
            },
            {
              函数名字
                "name": "get_forecast",
              这里是我们之前注释的地方
                "description": "获取美国天气 \n    \n    Args:\n        latitude : 精度\n        longitude : 纬度\n    ",
                "inputSchema": {  要求输入的格式是什么
                    "properties": {
                        "latitude": {
                            "title": "Latitude",
                            "type": "number"
                        },
                        "longitude": {
                            "title": "Longitude",
                            "type": "number"
                        }
                    },
                    "required": [ 必须要的参数
                        "latitude",
                        "longitude"
                    ],
                    "title": "get_forecastArguments",
                    "type": "object"
                }
            }
        ]
    }
}
```

这样我们Cline和MCP的初始连接结束 我们接下来看看 大模型参与后的交互

```json
输入: {
    "method": "tools/call",
    "params": {
        "name": "get_forecast",
        "arguments": {
            "latitude": 40.7128,
            "longitude": -74.006
        }
    },
    "jsonrpc": "2.0",
    "id": 4
}
```

这里就是大模型识别mcp服务后传入的工具

```json
输出: {
    "jsonrpc": "2.0",
    "id": 4,
    "result": {
        "content": [
            {
                "type": "text",
                "text": "\nTonight:\。。。。。。。"
            }
        ],
        "isError": false
    }
}
```

这里就是mcp服务返回的数据

这样我们就知道了 MCP和 MCP host之间的传递 我们可以直接通过控制台实现调试MCP服务 只需要传递Cline的输入给 MCP 就可以实现脱离Cline实现对话

![image-20250514104413961](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250514104413961.png)

# MCP服务调试 

对写好的MCP服务进行调试

首先安装node 这里是macos 通过nvm安装

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
```

```
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
```

检查安装

```
nvm -v  
```

安装node

```
nvm install node  
```

然后就可以了 去 mcp服务下 启动

```
mcp dev server.py  
```

这里需要前面是通过 **uv add “mcp[cli]”** 安装的

![image-20250514145354996](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250514145354996.png)

这里我们就可以完整的看到交互了

# 踩坑

其实是python语言写的问题 记录在这吧

## exceptions must derive from BaseException

这里是因为 我直接 raise 了 cmd 写错了。raise 只能返回错误

并且 最好是自定义返回结果

```
class scanError(Exception):
 def __init__(self, message: str, result: dict | None = None):
        super().__init__(message)     # 让 str(e) 仍然是 message
        self.result = result          # 额外挂载自定义属性
```

然后调用

```
if scan_error:
	raise scanErro("扫描失败", result)
```

## Error executing tool information_search: 'coroutine' object has no attribute 'communicate'

因为 proc 忘记加 await

```
    proc = await asyncio.create_subprocess_exec(
        *cmd,
        stdout= asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE  
    )
```

