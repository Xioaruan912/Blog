# 搭建

ubuntu为例

```
git clone https://github.com/PastKing/tgbot-verify.git
cd tgbot-verify
```

```
pip install -r requirements.txt
```

如果安装`pycairo` 报错

```
sudo apt-get update
sudo apt-get install -y libcairo2-dev pkg-config
```

然后执行

```
pip install -r requirements.txt
playwright install chromium
```

# 安装`mysql`

```
sudo apt install mysql-server -y
sudo mysql
```

```
CREATE DATABASE tgbot_verify CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'tgbot_user'@'localhost' IDENTIFIED BY 'your_password_here';
GRANT ALL PRIVILEGES ON tgbot_verify.* TO 'tgbot_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

# 启动

```
python bot.py
```

即可实现