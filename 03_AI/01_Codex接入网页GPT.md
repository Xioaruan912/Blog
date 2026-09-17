# 安装环境

首先告诉你本地的Codex

帮我安装

```
npm install -g @waishnav/devspace
# 或使用一键脚本
curl -fsSL https://raw.githubusercontent.com/Xioaruan912/devspace-ssh/main/install.sh | bash
cloudflared 
```

这样就可以了

# 初始化devspace

```
PS C:\Users\win> devspace init
┌  DevSpace setup
│
◆  Where will you use DevSpace?
│  ◻ ChatGPT (Connect ChatGPT to projects on this computer.)
│  ◼ Coding Agents (Use DevSpace from Codex, Claude Code, OpenCode, Pi, and similar tools.)
│  ↑/↓ to navigate • Space: select • Enter: confirm
```

选择GPT

```
PS C:\Users\win> devspace init
┌  DevSpace setup
│
◇  Where will you use DevSpace?
│  Coding Agents
│
◆  Which Coding Agents should be available?
│  ◼ codex (available)
│  ◼ claude (available)
│  ◼ opencode (available)
│  ◼ pi (available)
│  ◻ cursor
│  ◻ copilot
│  ◻ grok
│  ↑/↓ to navigate • Space: select • Enter: confirm
└
```

选codex

通过 下面命令检查配置

```
devspace doctor
devspace config get
```

检查允许的路径 如果不行就重置

```
npx @waishnav/devspace init --force
```

最后执行 启动服务

```
npx @waishnav/devspace serve
```

访问

```
http://127.0.0.1:7676/mcp
```

如果有内容就是ok了

# 配置CF

我们需要构建 tunnel 

![image-20260829201512093](https://raw.githubusercontent.com/Xioaruan912/pic/main/20260829201512131.png)

然后复制命令进入控制台(管理员)

如果你有域名 可以添加一个域名

 ![image-20260829201819425](https://raw.githubusercontent.com/Xioaruan912/pic/main/20260829201819466.png)

然后配置

```
devspace config set publicBaseUrl https://devspace.你的域名.com
devspace serve

```

启动信息应该有如下内容

```
public base url: https://devspace.example.com
allowed hosts: ..., devspace.example.com

```

现在进入 网页GPT

配置  MCP服务 需要进入**开发者模式**

![img](https://raw.githubusercontent.com/Xioaruan912/pic/main/20260829202001845.png)

```
名称：DevSpace
MCP 服务器 URL：https://devspace.example.com/mcp
身份验证：OAuth
勾选风险确认
```

![img](https://raw.githubusercontent.com/Xioaruan912/pic/main/20260829202013126.png)

连接时会出现 `Connect DevSpace` 页面。Owner password 不在 Cloudflare 后台，而是在本机

```
cat ~/.devspace/auth.json
```

只复制 `ownerToken` 的值输入

然后问ChatGPT现在可以看到什么 验证是不是在目录下 即可

# 设定自启动

我是在wsl里安装的 所以我这里配置开机自启动

```
which devspace
```

```
sudo vim /etc/systemd/system/devspace.service
```

```
[Unit]
Description=DevSpace MCP Server
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=root
WorkingDirectory=修改工作目录！！！！！！
ExecStart=/usr/local/bin/devspace serve
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
```

```
sudo systemctl daemon-reload
sudo systemctl enable devspace.service
sudo systemctl start devspace.service
```

检查

```
systemctl status devspace.service
```

日志

```
journalctl -u devspace.service -f
```

