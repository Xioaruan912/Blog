# 配置防火墙防止探测

进入域名

![image-20250520151508548](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250520151508548.png)

自定义规则 

## 规则1 阻止特定国家探测

![image-20250520151544990](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250520151544990.png)

```
(not ip.geoip.country in {"JP" "CN"})
```

规则2 允许我们的IP访问

![image-20250520151610630](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250520151610630.png)

```
(ip.src in $ip)
```

![image-20250520151622916](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250520151622916.png)

这样就可以防止大部分探测