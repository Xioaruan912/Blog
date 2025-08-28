https://jellyfin.org/

# 搭建

在此之前你需要搭建完毕 openlist 有自己的webdav

然后安装以下脚本

```
curl -sSL -o Jellyfin.sh "https://raw.githubusercontent.com/Xioaruan912/Xcript/main/sh/Jellyfin.sh" && chmod +x Jellyfin.sh && ./Jellyfin.sh && rm Jellyfin.sh
```

配置rclone

```
rclone config
```

按照以下配置

https://slarker.me/unraid-jellyfin-webdav/

即可

```
mkdir -p /mnt/user/rclone/openlist
```

```
rclone mount list: /mnt/user/rclone/openlist \
  --umask 0022 \
  --default-permissions \
  --allow-other \
  --buffer-size 32M \
  --low-level-retries 200 \
  --dir-cache-time 2h \
  --vfs-read-chunk-size 64M \
  --vfs-read-chunk-size-limit 1G \
  --vfs-cache-mode full \
  --vfs-cache-max-size 20G \
  --vfs-cache-max-age 24h \
  --log-level INFO --log-file /var/log/rclone-openlist.log	
```

去jellyfin的docker compose中切换

```
version: "3.9"
services:
  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    restart: unless-stopped
    network_mode: "host"
    environment:
      - TZ=Asia/Shanghai
    volumes:
      - ./config:/config
      - ./cache:/cache
      - ./media:/media
      # ★ 把 rclone 挂载点映射进容器（只读）
      - /mnt/user/rclone/openlist:/mnt/openlist:ro

```

```
docker compose up -d
```

检测

```
docker exec -it jellyfin bash -lc 'ls -l /mnt/openlist/115/NAS'
```

# 影片要求如下

https://daftneko.com/archives/building-a-media-server

# 插件

[弹幕](https://github.com/cxfksword/jellyfin-plugin-danmu?tab=readme-ov-file)

![image-20250821120755404](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250821120755404.png)

![image-20250821120803188](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250821120803188.png)

![image-20250821120815200](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250821120815200.png)

点击安装即可