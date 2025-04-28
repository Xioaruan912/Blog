# 使用官方的 PHP 镜像作为基础镜像，基于 Apache
FROM php:7.4-apache

# 启用mod_rewrite模块，可能对某些CTF题目有用
RUN a2enmod rewrite

# 将当前目录的代码复制到容器中的 /var/www/html 目录
COPY . /var/www/html/

# 设置工作目录
WORKDIR /var/www/html

# 打开容器的80端口
EXPOSE 80

# 启动Apache服务（由镜像默认启动）
CMD ["apache2-foreground"]
