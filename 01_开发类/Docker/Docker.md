# 入门docker

docker是一个容器技术 通过Docker我们可以构建轻量化Linux系统 运行

下面演示基于ubuntu系统

镜像 用于构建容器 是一个摸具

# 安装docker

```
curl -sSL https://get.docker.com | bash

# For CentOS systems, also run:
systemctl enable docker
systemctl start docker
```

这样就成功安装docker

# Docker基本命令

## pull

通过pull命令从 docker.io下载镜像

```
docker pull docker.io/library/nginx:latest
```

也就是

```
docker pull 网站(上面是官网)/作者/docker容器:版本
```

如果从docker官方维护的仓库拉取可以直接省略 

```
docker pull nginx
```

```shell
root@hkbjnQPBC1HM:~# docker pull nginx
Using default tag: latest
latest: Pulling from library/nginx
dad67da3f26b: Downloading  12.26MB/28.23MB
4eb3a9835b30: Downloading  12.07MB/43.97MB
021db26e13de: Download complete 
397cc88dcd41: Download complete 
5f4a88bd8474: Download complete 
66467f827546: Download complete 
f05e87039331: Download complete 
```

## run

通过镜像启动容器

首要内容就是

```
docker run
```

命令，这是docker的基础

### -p

这是端口映射的内容

```
主机端口:容器端口
```

这样将容器端口映射到主机端口

```
docker run  -p 6666:80 nginx
```

本机的6666端口 作为容器的80映射 这样我们访问 127.0.0.1:6666 就可以看到nginx的页面

### -v

容器文件绑定

和端口转发类似

我们可以直接将本地目录和容器目录绑定 这样可以实现简易的备份和数据查看

```
docker run  -p 6666:80 -v /test/html:/usr/share/nginx/html nginx
```

并且使用绑定挂载的时候 宿主机目录覆盖容器目录 而且宿主机目录是自动创建的 直接修改宿主机的目录文件即可

```
root@hkbjnQPBC1HM:/test/html# curl 127.0.0.1:6666
hee
```

我们可以生成一个统一挂载卷

```
docker volume create nginx_file
```

这样我们在启动的时候就可以通过挂载卷直接映射

```
docker run -p 6666:80 -v nginx_file:/usr/share/nginx/html nginx
```

这个时候启动是在前端 我们可以分离运行

```
docker run -d -p 6666:80 -v nginx_file:/usr/share/nginx/html nginx
```

挂载卷的真实目录

```
docker volume inspect nginx_file 
```

```
root@hkbjnQPBC1HM:/test/html# docker volume inspect nginx_file 
[
    {
        "CreatedAt": "2025-06-29T01:18:51Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/nginx_file/_data",
        "Name": "nginx_file",
        "Options": null,
        "Scope": "local"
    }
]
```

并且挂载卷在第一次使用的时候直接复制宿主机内容

```
docker volume list 列出所有
docker volume rm 名字 删除名字的
docker volume prune -a 删除所有没有被使用的挂载卷
```

### -e

写入环境变量

许多docker 是通过环境变量传递初始化账号密码

例如mongodb

```
https://hub.docker.com/_/mongo
```

```
docker run -d  \
	-p 8888:27017 \
	-e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
	-e MONGO_INITDB_ROOT_PASSWORD=secret \
	mongo
```

### --name

为容器起名字 这样可以更好的操作

```
docker run -d --name my_mongo \
	-p 8888:27017 \
	-e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
	-e MONGO_INITDB_ROOT_PASSWORD=secret \
	mongo
```

### -it

创建完毕后就进入容器进行交互

```
docker run -d --name my_mongo -it \
	-p 8888:27017 \
	-e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
	-e MONGO_INITDB_ROOT_PASSWORD=secret \
	mongo
```

### --rm

如果容器被停止 就直接删除

```
docker run -d --name my_mongo -it --rm \
	-p 8888:27017 \
	-e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
	-e MONGO_INITDB_ROOT_PASSWORD=secret \
	mongo
```



### --restart

主要是调试的时候 使用

```
docker run -d --name my_mongo --restart always \
	-p 8888:27017 \
	-e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
	-e MONGO_INITDB_ROOT_PASSWORD=secret \
	mongo
```

这里设置 每次容器关闭就重新执行 主要用于宿主机断电等

```
docker run -d --name my_mongo -restart unless-stopped \
	-p 8888:27017 \
	-e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
	-e MONGO_INITDB_ROOT_PASSWORD=secret \
	mongo
```

这里和always类似 但是如果手动关闭就不会重启

## ps

展示当前宿主机的容器状态

```
root@hkbjnQPBC1HM:/test/html# docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                  NAMES
0da9171bec8c   nginx     "/docker-entrypoint.…"   3 minutes ago   Up 3 minutes   0.0.0.0:6666->80/tcp   cool_kirch
随机生成的ID		镜像的名字	启动命令				  什么时候创建的     状态		   网络情况					随机生成名字
```

如果我们忘记如何启动容器的 我们通过

```
docker inspect ID 就可以直接查看
```

## rm

删除容器

```
docker rm -f ID
-f 主要是删除正在运行的容器
```

## exec

进入容器内部操作

```
docker exec  -it DI /bin/sh
```

# DOCKERFILE

这是制作模具的图纸 完整告诉了我该如何构建 

## 制作镜像

![Capturer_2025-06-29_093528_438](https://raw.githubusercontent.com/Xioaruan912/pic/main/Capturer_2025-06-29_093528_438.gif)

## 编写DockerFile

```dockerfile
FROM python:3.13-slim

WORKDIR /app

COPY . . 

RUN pip install -r requirments.txt

EXPOSE 8000

CMD ["python3","main.py"]
```

这里开始解释

```
FROM 是选择一个基础镜像环境 这里主要运行python代码 所以基础是python环境

WORKDIR 将容器设置工作目录 后面文件或者其他操作都是在该目录下

COPY 将宿主文件复制到WORKDIR文件下

RUN 执行一次Linux命令

EXPOSE 声明暴露端口 只是声明 主要还是通过-p

CMD 每个DockerFile唯一 唯一的启动命令
```

## 构建镜像

``` 。
docker build  -t 镜像名字 .
```

这样就构建了一个镜像

使用

```
docker run -p 8000:8000 镜像名字 
```

就可以很快速构建

## 推送DockerHub

首先去浏览器登陆Docker Hub

```
https://hub.docker.com/
```

你的用户名就是对应上面的命名空间

这个时候你就在命令行输入 

```
docker login
```

根据操作登入即可

随后我们重新打个镜像

```
docker build -t 用户名/docker_test . 
```

```
docker push 名字/docker_test 
```

这样你以后就可以通过

```
docekr pull docker.io/用户名/docker_test
```

拉取镜像

# Docker的网络

这里可以通过 

```
技术爬爬虾
```

视频查看 里面有动图

## bridge 桥接模式

### 创建子网

```
docker network create network1
```

然后我们通过添加容器到子网 这样 不同容器可以互相交互

```
docker run -d --name my_mongo -restart unless-stopped \
	-e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
	-e MONGO_INITDB_ROOT_PASSWORD=secret \
	--network network1 \ 添加进入子网
	mongo
```

这里的命令可以发现我们没有通过 -p绑定 所以无法通过宿主机访问 

但是我们可以通过其他的方法 使用 mongo-express 容器 这是个web访问mongo操作的容器我们添加到一个子网中

```
docker run -it --rm \
    --network network1 \
    --name mongo-express \
    -p 8081:8081 \
    -e ME_CONFIG_OPTIONS_EDITORTHEME="ambiance" \
    -e ME_CONFIG_MONGODB_SERVER="my_mongo" \  这里要填写mongo的服务 可以发现我们直接将容器名字传递给这个
    -e ME_CONFIG_BASICAUTH_USERNAME="user" \
    -e ME_CONFIG_BASICAUTH_PASSWORD="fairly long password" \
    mongo-express

```

这里要说明

### docker的DNS机制

docker的DNS是一个子网内 可以通过用户 或者系统生成的名字 作为 host 访问

例如

```
docker exec -it my_mongo /bin/sh
ping mongo-express
```

是可以直接返回内网IP的

这样我们就可以通过mongo-express访问mongo服务 从而保护数据库安全

## host模式

```
docker run -it --rm \
    --network host \
    --name mongo-express \
    -e ME_CONFIG_OPTIONS_EDITORTHEME="ambiance" \
    -e ME_CONFIG_MONGODB_SERVER="my_mongo" \  这里要填写mongo的服务 可以发现我们直接将容器名字传递给这个
    -e ME_CONFIG_BASICAUTH_USERNAME="user" \
    -e ME_CONFIG_BASICAUTH_PASSWORD="fairly long password" \
    mongo-express

```

这里我们添加了 host模式 并且没有写 -p 但是这里就是默认将 mongo-express 直接映射到宿主机上 类似宿主机的一个服务

# docker compose

进入一个完整的开发 需要前后端内容

我们依照上面的 mongo组件 编写一个docker compose

docker compose 主要通过 docker-compose.yaml

这样我们不需要每个容器都去run 只要通过docker  compose 命令就可以一键启动多个容器

```
services:
  my_mongo:  #名字
    image: mongo #dockerhub的镜像
    environment: #需要添加的环境
      - MONGO_INITDB_ROOT_USERNAME=mongoadmin
      - MONGO_INITDB_ROOT_PASSWORD=secret
    volumes:
      - /my/mongodir:/data/db  #-v
  my_mongo_express:
    image: mongo-express
    ports:
      - 8081:8081
    environment:
      - ME_CONFIG_OPTIONS_EDITORTHEME="ambiance"
      - ME_CONFIG_MONGODB_SERVER="my_mongo"
      - ME_CONFIG_BASICAUTH_USERNAME="user"
      - ME_CONFIG_BASICAUTH_PASSWORD="pass"
```

这样就可以快速构建了

```
services 声明服务
image 拉取的镜像
environment 环境
volumes 文件
ports 端口
```

如果需要添加拉取顺序

```
services:
  my_mongo:  #名字
    image: mongo #dockerhub的镜像
    environment: #需要添加的环境
      - MONGO_INITDB_ROOT_USERNAME=mongoadmin
      - MONGO_INITDB_ROOT_PASSWORD=secret
    volumes:
      - /my/mongodir:/data/db  #-v
  my_mongo_express:
    image: mongo-express
    ports:
      - 8081:8081
    environment:
      - ME_CONFIG_OPTIONS_EDITORTHEME="ambiance"
      - ME_CONFIG_MONGODB_SERVER="my_mongo"
      - ME_CONFIG_BASICAUTH_USERNAME="user"
      - ME_CONFIG_BASICAUTH_PASSWORD="pass"
    depends_on:
      - my_mongo  #要求先拉取my_mongo
```

命令

```
root@hkbjnQPBC1HM:~# docker compose up -d
[+] Running 18/18
 ✔ my_mongo_express Pulled                                                  52.0s 
 ✔ my_mongo Pulled                                                         148.3s 
[+] Running 3/3
 ✔ Network root_default               Created                                0.2s 
 ✔ Container root-my_mongo-1          Started                                1.0s 
 ✔ Container root-my_mongo_express-1  Started
```

可以发现docker-compose  默认创建一个子网

```
docker compose up -d 后台启动
docker compose down 删除容器
docker compose stop 停止容器
docker compose restart 重启
```

到此docker结束

所以docker工作流程

```
dockerfile构建---- push dockerhub ---- 编写docker-compose.yaml 拉取即可
```

