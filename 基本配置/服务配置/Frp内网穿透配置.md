## 服务器端

下载frp后 配置frps.ini文件

```
[common]
# frp监听的端口，默认是7000，可以改成其他的
bind_port = 7000
# 授权码，请改成更复杂的
token = token

# frp管理后台端口，请按自己需求更改
dashboard_port = 7500
# frp管理后台用户名和密码，请改成自己的
dashboard_user = admin
dashboard_pwd = 密码
enable_prometheus = true

# frp日志配置
log_file = /var/log/frps.log
log_level = info
log_max_days = 3
```

```
./frps -c frps.ini
```

启动服务

## 内网机器端

```
# 服务端配置
[common]
server_addr = 服务器ip
# 请换成设置的服务器端口
server_port = 7000
token = token

[rdp1]
type = tcp
local_ip = 127.0.0.1
local_port = 3389
# 远程端口
remote_port = 7089
```

这里配置问问gpt或者网络上查找即可