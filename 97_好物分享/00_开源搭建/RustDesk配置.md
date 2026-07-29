主要是服务器端

```sh
#!/usr/bin/env bash
# install_rustdesk.sh
# 用途：下载并解压 RustDesk 服务端 i386 版本

set -e  # 任一步骤失败则退出脚本

# 配置参数
VERSION="1.1.14"
ARCH="i386"
ZIP_NAME="rustdesk-server-linux-${ARCH}.zip"
DOWNLOAD_URL="https://github.com/rustdesk/rustdesk-server/releases/download/${VERSION}/${ZIP_NAME}"

echo "→ 正在下载 ${DOWNLOAD_URL} ..."
wget -O "${ZIP_NAME}" "${DOWNLOAD_URL}"

echo "→ 创建 rustdesk 目录并移动压缩包 ..."
mkdir -p rustdesk
mv "${ZIP_NAME}" rustdesk/rustdesk.zip

echo "→ 解压压缩包 ..."
cd rustdesk
unzip -q rustdesk.zip

echo "→ 设置执行权限 ..."
chmod -R 777 i386

echo "→ 进入 i386 目录。完成！"
cd i386
pwd

```

通过脚本可以快速下载安装包

通过

screen

```
hbbr
hbbs 开启即可
```

然后去获取key 执行完后自动生成

![image-20250516153948741](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250516153948741.png)

配置即可