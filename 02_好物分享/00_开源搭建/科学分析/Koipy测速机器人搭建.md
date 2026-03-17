这是Fulltclash的升级 可以通过构建多后端实现测速

通过tg获取最新的 安装包

# tg机器人安装

```
mkdir koipy
cd koipy
touch config.yaml
unzip koipy-linux-amd64.zip
sudo chmod +x koipy && ./koipy 
```

填写config内容

```
license: xxxxxxxxxxx  # 激活码，必填。否则无法使用
# 如果bot需要代理：
bot:
  proxy: socks5://127.0.0.1:7890 # socks5代理
  bot-token: 123456:abcdefg # bot的token, 首次启动必填，替换你自己的
  #proxy: http://127.0.0.1:7890 # http代理也支持
  #api-id:  # telegram的 api_id 选填
  #api-hash:  # telegram的 api_hash 选填
```

koipy自带 api 所以不需要申请了

![image-20251107020621516](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20251107020621516.png)

这样机器人构建成功了 现在构建后端

# 后端

https://github.com/AirportR/miaospeed/releases/tag/4.6.2

获取后端

```
./miaospeed-linux-amd64 server -bind 0.0.0.1:8765 -path miaospeed -token 123123N2e{Q?W -mtls
```

然后回去tg机器人

```
slaveConfig: # 后端配置
  slaves: # 后端列表，注意是数组类型
    - type: miaospeed # 固定值，目前只这个支持
      id: "localmiaospeed" # 后端id
      token: "123123N2e{Q?W" # 连接密码
      address: "127.0.0.1:8765" # 后端地址
      path: "/miaospeed" # websocket的连接路径，只有路径正确才能正确连接，请填写复杂的路径，防止路径被爆破。可以有效避免miaospeed服务被网络爬虫扫描到.
      skipCertVerify: true # 跳过证书验证，如果你不知道在做什么，请写此默认值
      tls: true # 启用加密连接，如果你不知道在做什么，请写此默认值
      invoker: "114514" # bot调用者，请删掉此行或者随便填一个字符串
      buildtoken: "MIAOKO4|580JxAo049R|GEnERAl|1X571R930|T0kEN" # 默认编译token  如果你不知道在做什么，请写此默认值
      comment: "本地miaospeed后端" # 后端备注，显示在bot页面的
      hidden: false # 是否隐藏此后端
      option: # 可选配置
        downloadDuration: 8 # 测试时长
        downloadThreading: 4 # 测速线程
        downloadURL: https://dl.google.com/dl/android/studio/install/3.4.1.0/android-studio-ide-183.5522156-windows.exe # 测速文件
        pingAddress: https://cp.cloudflare.com/generate_204 # 延迟测试地址
        pingAverageOver: 3 # ping多少次取平均
        stunURL: udp://stun.ideasip.com:3478 # STUN地址，测udp连通性的
        taskRetry: 3 # 后端任务重试
```

一个完整的配置如下

```
admin:
- ！！！！！！！！！！！删除即可 自动填写！！！！！！！！！！！！！！！！
bot:
  antiGroup: false
  autoResetCommands: false
  bot-token: ！！！！！！！！！！！！！！！！！！！！！！！token！！！！！！！！！！！！！！！！！！！！！！！！！！
  bypassMode: false
  cacheTime: 60
  commands: []
  echoLimit: 0.8
  inviteGroup: []
  ipv6: false
  proxy: socks5://127.0.0.1:7890
  strictMode: false
callbacks:
  onMessage: ''
  onPreSend: ''
  onResult: ''
image:
  color:
    background:
      inbound:
        alpha: 255
        end-color: '#ffffff'
        label: 0.0
        name: ''
        value: '#ffffff'
      outbound:
        alpha: 255
        end-color: '#ffffff'
        label: 0.0
        name: ''
        value: '#ffffff'
      script:
        alpha: 255
        end-color: '#ffffff'
        label: 0.0
        name: ''
        value: '#ffffff'
      scriptTitle:
        alpha: 255
        end-color: '#ffffff'
        label: 0.0
        name: ''
        value: '#EAEAEA'
      speed:
        alpha: 255
        end-color: '#ffffff'
        label: 0.0
        name: ''
        value: '#ffffff'
      speedTitle:
        alpha: 255
        end-color: '#ffffff'
        label: 0.0
        name: ''
        value: '#EAEAEA'
      topoTitle:
        alpha: 255
        end-color: '#ffffff'
        label: 0.0
        name: ''
        value: '#EAEAEA'
    delay: []
    font:
      alpha: 255
      end-color: '#ffffff'
      label: 0.0
      name: ''
      value: '#000000'
    ipriskHigh:
      alpha: 255
      end-color: '#ffffff'
      label: 0.0
      name: ''
      value: '#ffffff'
    ipriskLow:
      alpha: 255
      end-color: '#ffffff'
      label: 0.0
      name: ''
      value: '#ffffff'
    ipriskMedium:
      alpha: 255
      end-color: '#ffffff'
      label: 0.0
      name: ''
      value: '#ffffff'
    ipriskVeryHigh:
      alpha: 255
      end-color: '#ffffff'
      label: 0.0
      name: ''
      value: '#ffffff'
    na:
      alpha: 255
      end-color: '#8d8b8e'
      label: 0.0
      name: ''
      value: '#8d8b8e'
    'no':
      alpha: 255
      end-color: '#ee6b73'
      label: 0.0
      name: ''
      value: '#ee6b73'
    outColor: []
    speed: []
    wait:
      alpha: 255
      end-color: '#dcc7e1'
      label: 0.0
      name: ''
      value: '#dcc7e1'
    warn:
      alpha: 255
      end-color: '#fcc43c'
      label: 0.0
      name: ''
      value: '#fcc43c'
    xline:
      alpha: 255
      end-color: '#ffffff'
      label: 0.0
      name: ''
      value: '#E1E1E1'
    'yes':
      alpha: 255
      end-color: '#bee47e'
      label: 0.0
      name: ''
      value: '#bee47e'
    yline:
      alpha: 255
      end-color: '#ffffff'
      label: 0.0
      name: ''
      value: '#EAEAEA'
  compress: false
  emoji:
    enable: true
    source: TwemojiLocalSource
  endColorsSwitch: false
  font: /root/koipy/resources/alibaba-Regular.otf
  invert: false
  pixelThreshold: 2500x3500
  save: true
  speedEndColorSwitch: false
  speedFormat: bit/decimal
  title: ！！！！！！！！！！！！！！！！！！！！title ！！！！！！！！！！！！！！！！！！！
  watermark:
    alpha: 16
    angle: -16.0
    color:
      alpha: 16
      end-color: '#ffffff'
      label: 0.0
      name: ''
      value: '#000000'
    enable: false
    row-spacing: 1
    shadow: false
    size: 64
    start-y: 0
    text: 只是一个水印
    trace: false
license:  ！！！！！！！！！！！！！！！！！许可证！！！！！！！！！！！！！！！！！！
log-level: INFO
rules: []
runtime:
  disableSubCvt: false
  duration: 10
  entrance: true
  excludeFilter: ''
  includeFilter: ''
  ipstack: true
  pingURL: https://www.gstatic.com/generate_204
  protectContent: false
  sort: 订阅原序
  speedFiles:
  - https://dl.google.com/dl/android/studio/install/3.4.1.0/android-studio-ide-183.5522156-windows.exe
  speedNodes: 300
  speedThreads: 4
scriptConfig:
  scripts: []
slaveConfig:
  healthCheck:
    autoHideOnFailure: false
    numSamples: 10
    showStatusStyle: default
  showID: true
subconverter:
  address: 127.0.0.1:25500
  enable: false
  exclude: ''
  include: ''
  tls: false
substore:
  autoDeploy: false
  enable: false
translation:
  lang: zh_CN
user: []
scriptConfig:
  scripts: # 脚本载入
    - type: gofunc # 表示是miaospeed的内置实现
      name: "TEST_PING_RTT" # 特殊保留名称，当设置为这些特殊保留值时会覆写程序内部的默认配置，更多的特殊保留值请参阅这里: https://github.com/airportr/miaospeed/blob/master/interfaces/matrix.go#L3
      rank: -100 # 排序
    - type: gojajs # 表示miaospeed主流脚本类型
      name: "示例脚本" # 脚本名称
      rank: 0 # 排序，越小排在越前面
      content: | # 脚本内容
        const C_NA = '142,140,142';
        const C_UNL = '186,230,126';
        const C_FAIL = '239,107,115';
        const C_UNK = '92,207,230';

        function handler() {
          return {
              text: '失败',
              background: C_UNK,
          }
        }
    - type: gojajs
      name: "Youtube"
      rank: 0
      content: "resources/scripts/builtin/youtube.js" # 也可以指定一个文件路径
    - type: gojajs
      name: "Disney+"
      rank: 1
      content: "resources/scripts/builtin/disney+.js"
    - type: gojajs
      name: "OpenAI"
      rank: 2
      content: "resources/scripts/builtin/openai.js"
    - type: gojajs
      name: "Tiktok"
      rank: 3
      content: "resources/scripts/builtin/tiktok.js"
    - type: gojajs
      name: "维基百科"
      rank: 4
      content: "resources/scripts/builtin/wikipedia.js"
    - type: gojajs
      name: "Claude"
      rank: 5
      content: "resources/scripts/builtin/Claude.js"
    - type: gojajs
      name: "Bilibili"
      rank: 6
      content: "resources/scripts/builtin/bilibili.js"
    - type: gojajs
      name: "微软Copilot"
      rank: 7
      content: "resources/scripts/builtin/copilot.js"
    - type: gojajs
      name: "Spotify"
      rank: 8
      content: "resources/scripts/builtin/spotify.js"
    - type: gojajs
      name: "Viu"
      rank: 9
      content: "resources/scripts/builtin/viu.js"
    - type: gojajs
      name: "IP风险"
      rank: 11
      content: "resources/scripts/builtin/iprisk.js"
    - type: gojajs
      name: "DNS区域"
      rank: 10
      content: "resources/scripts/builtin/dns.js"
slaveConfig: # 后端配置
  slaves: # 后端列表，注意是数组类型
    - type: miaospeed # 固定值，目前只这个支持
      id: "ali" # 后端id
      token: "123123N2e{Q?W" # 连接密码
      address: "1111111:8765" # 后端地址
      path: "/miaospeed" # websocket的连接路径，只有路径正确才能正确连接，请填写复杂的路径，防止路径被爆破。可以有效避免miaospeed服务被网络爬虫扫描到.
      skipCertVerify: true # 跳过证书验证，如果你不知道在做什么，请写此默认值
      tls: true # 启用加密连接，如果你不知道在做什么，请写此默认值
      buildtoken: "MIAOKO4|580JxAo049R|GEnERAl|1X571R930|T0kEN" # 默认编译token  如果你不知道在做什么，请写此默认值
      comment: "阿里云 200M" # 后端备注，显示在bot页面的
      hidden: false # 是否隐藏此后端
    - type: miaospeed # 固定值，目前只这个支持
      id: "yian" # 后端id
      token: "123123N2e{Q?W" # 连接密码
      address: "1111111:57759" # 后端地址
      path: "/miaospeed" # websocket的连接路径，只有路径正确才能正确连接，请填写复杂的路径，防止路径被爆破。可以有效避免miaospeed服务被网络爬虫扫描到.
      skipCertVerify: true # 跳过证书验证，如果你不知道在做什么，请写此默认值
      tls: true # 启用加密连接，如果你不知道在做什么，请写此默认值
      buildtoken: "MIAOKO4|580JxAo049R|GEnERAl|1X571R930|T0kEN" # 默认编译token  如果你不知道在做什么，请写此默认值
      comment: "亿安云 1G" # 后端备注，显示在bot页面的
      hidden: false # 是否隐藏此后端
    - type: miaospeed # 固定值，目前只这个支持
      id: "claw" # 后端id
      token: "123123N2e{Q?W" # 连接密码
      address: "1111111:8765" # 后端地址
      path: "/miaospeed" # websocket的连接路径，只有路径正确才能正确连接，请填写复杂的路径，防止路径被爆破。可以有效避免miaospeed服务被网络爬虫扫描到.
      skipCertVerify: true # 跳过证书验证，如果你不知道在做什么，请写此默认值
      tls: true # 启用加密连接，如果你不知道在做什么，请写此默认值
      buildtoken: "MIAOKO4|580JxAo049R|GEnERAl|1X571R930|T0kEN" # 默认编译token  如果你不知道在做什么，请写此默认值
      comment: "claw 1G" # 后端备注，显示在bot页面的
      hidden: false # 是否隐藏此后端
```

