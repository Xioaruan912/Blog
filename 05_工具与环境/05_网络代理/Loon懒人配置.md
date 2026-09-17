```
[General]
mitm-on-wifi-access = false
ip-mode = v4-only
dns-server = system
sni-sniffing = true
disable-stun = true
dns-reject-mode = LoopbackIP
domain-reject-mode = DNS
udp-fallback-mode = REJECT
wifi-access-http-port = 7222
wifi-access-socks5-port = 7221
allow-wifi-access = false
interface-mode = auto
test-timeout = 5
disconnect-on-policy-change = false
switch-node-after-failure-times = 3
internet-test-url = https://www.youtube.com
proxy-test-url = https://www.youtube.com
resource-parser = https://raw.githubusercontent.com/sub-store-org/Sub-Store/release/sub-store-parser.loon.min.js
geoip-url = https://github.com/Masaiki/GeoIP2-CN/raw/release/Country.mmdb
ipasn-url = https://raw.githubusercontent.com/P3TERX/GeoLite.mmdb/download/GeoLite2-ASN.mmdb
skip-proxy = 192.168.0.0/16,10.0.0.0/8,172.16.0.0/12,localhost,*.local,e.crashlynatics.com
bypass-tun = 10.0.0.0/8,100.64.0.0/10,127.0.0.0/8,169.254.0.0/16,172.16.0.0/12,192.0.0.0/24,192.0.2.0/24,192.88.99.0/24,192.168.0.0/16,198.51.100.0/24,203.0.113.0/24,224.0.0.0/4,255.255.255.255/32

[Proxy]

[Remote Proxy]


[Remote Filter]
# 远程节点订阅正则筛选
美国 = NameRegex, FilterKey = "(?i)(美国|波特兰|达拉斯|俄勒冈|凤凰城|费利蒙|硅谷|拉斯维加斯|洛杉矶|圣何塞|圣克拉拉|西雅图|芝加哥|🇺🇸|US|USA)"
香港 = NameRegex, FilterKey = "(?i)(香港|港|hong|HK|HKG|🇭🇰)"
日本 = NameRegex, FilterKey = "(?i)(日本|东京|大阪|泉日|埼玉|🇯🇵|JP|Japan)"
台湾 = NameRegex, FilterKey = "(?i)(台|台湾|TW|Taiwan)"
新加坡 = NameRegex, FilterKey = "(?i)(狮城|新加坡|🇸🇬|SG|Singapore)"

[Proxy Group]
## 策略组
## 将分流规则传递过来的网络请求进行分发
# 可供手动选择的所有节点
Proxy = select,MyProxy,url = http://cp.cloudflare.com/generate_204,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Filter/Proxy.png
# 自动选择最优节点-HK
Auto-HK = url-test,香港,url = http://www.gstatic.com/generate_204,interval = 600,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Filter/Auto.png
# 服务器按地区分组策略
# > 美国
US = select,美国,url = http://cp.cloudflare.com/generate_204,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Country/US.png
# > 香港
HK = select,香港,url = http://cp.cloudflare.com/generate_204,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Country/HK02.png
# > 日本
JP = select,日本,url = http://cp.cloudflare.com/generate_204,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Country/JP.png
# > 台湾
TW = select,台湾,url = http://cp.cloudflare.com/generate_204,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Country/TW.png
# > 新加坡
SG = select,新加坡,url = http://cp.cloudflare.com/generate_204,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Country/SG.png
# OutSide策略
OutSide = select,US,,HK,JP,TW,SG,FINAL,DIRECT,url = http://cp.cloudflare.com/generate_204,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Filter/Outside.png
# GlobalMedia策略
GlobalMedia = select,US,,HK,JP,TW,SG,FINAL,DIRECT,url = http://cp.cloudflare.com/generate_204,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Filter/GMedia.png
# 国外媒体细分策略
# > YouTube策略
YouTube = select,US,HK,JP,TW,SG,FINAL,DIRECT,url = http://cp.cloudflare.com/generate_204,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Filter/Youtube.png
# > Spotify策略
Spotify = select,US,HK,JP,TW,SG,FINAL,DIRECT,url = http://cp.cloudflare.com/generate_204,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Filter/Spotify.png
# 国内媒体细分策略
# > BiliBili策略
Bilibili = select,HK,TW,DIRECT,url = http://cp.cloudflare.com/generate_204,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Filter/Bilibili.png
# 软件&服务策略
# > Telegram策略
Telegram = select,US,HK,JP,TW,SG,FINAL,DIRECT,url = http://cp.cloudflare.com/generate_204,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Filter/Telegram.png
# > OpenAI
OpenAI = select,US,HK,JP,TW,SG,FINAL,DIRECT,url = http://cp.cloudflare.com/generate_204,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Filter/OpenAI.png
# > Netflix
Netflix = select,US,HK,JP,TW,SG,FINAL,DIRECT,url = http://cp.cloudflare.com/generate_204,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Filter/Netflix.png
# Mainland策略-国内访问
Mainland = select,US,HK,JP,TW,SG,FINAL,DIRECT,url = http://cp.cloudflare.com/generate_204,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Filter/Mainland.png
# Advertising策略-去广告
Advertising = select,DIRECT,REJECT,url = http://cp.cloudflare.com/generate_204,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Filter/AdBlock.png
# FINAL策略：如果以上的策略均未被匹配到，则听从此策略组的规定
FINAL = select,Auto-HK,Proxy,DIRECT,url = http://cp.cloudflare.com/generate_204,img-url = https://raw.githubusercontent.com/erdongchanyo/icon/main/Policy-Filter/Final01.png

[Remote Rule]
## 远程分流规则订阅
## 将网络请求进行分流，网络请求的走向(是否能成功访问)由匹配到的策略组决定
# OutSide规则
https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Loon/OutSide/OutSide.list, policy=OutSide, tag=OutSide规则, enabled=true
# GlobalMedia规则
https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Loon/GlobalMedia/GlobalMedia.list, policy=GlobalMedia, tag=GlobalMedia规则, enabled=true
# YouTube规则
https://rule.kelee.one/Loon/YouTube.lsr, policy=YouTube, tag=YouTube规则, enabled=true
# Spotify规则
https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Loon/Spotify/Spotify.list, policy=Spotify, tag=Spotify规则, enabled=true
# BiliBili规则
https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Loon/BiliBili/BiliBili.list, policy=BiliBili, tag=BiliBili规则, enabled=true
# Telegram规则
https://rule.kelee.one/Loon/Telegram.lsr, policy=Telegram, tag=Telegram规则, enabled=true
# OpenAI规则
https://rule.kelee.one/Loon/OpenAI.lsr, policy=YouTube, tag=OpenAI规则, enabled=true
# Mainland规则
https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Loon/China/China.list, policy=Mainland, tag=Mainland规则, enabled=true
# Advertising规则
https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Loon/Advertising/Advertising.list, policy=Advertising, tag=Advertising规则, enabled=true
https://rule.kelee.one/Loon/Netflix.lsr, policy=Netflix, tag=Netflix规则, enabled=true
https://github.com/Moli-X/Tool/raw/X/Loon/Rules/TikTok.list, policy=TW, tag=海外抖音, enabled=true
https://github.com/Moli-X/Tool/raw/X/Loon/Rules/HTTPDNS.Block.list, policy=REJECT, tag=阻止常见DNS, enabled=true
https://github.com/Moli-X/Tool/raw/X/Loon/Rules/Reject.list, policy=REJECT, tag=广告列表, enabled=true
https://rule.kelee.one/Loon/iCloud.lsr, policy=DIRECT, tag=iCloud.lsr, enabled=true
https://rule.kelee.one/Loon/Weibo.lsr, policy=DIRECT, tag=Weibo.lsr, enabled=true
https://rule.kelee.one/Loon/WeChat.lsr, policy=DIRECT, tag=WeChat.lsr, enabled=true
https://rule.kelee.one/Loon/Speedtest.lsr, policy=OutSide, tag=Speedtest.lsr, enabled=true
https://rule.kelee.one/Loon/Pixiv.lsr, policy=YouTube, tag=Pixiv.lsr, enabled=true
https://rule.kelee.one/Loon/FeiZhu.lsr, policy=DIRECT, tag=FeiZhu.lsr, enabled=true
https://rule.kelee.one/Loon/DingTalk.lsr, policy=DIRECT, tag=DingTalk.lsr, enabled=true
https://rule.kelee.one/Loon/DiDi.lsr, policy=DIRECT, tag=DiDi.lsr, enabled=true
https://rule.kelee.one/Loon/Apple.lsr, policy=DIRECT, tag=Apple.lsr, enabled=true
https://rule.kelee.one/Loon/AppStore.lsr, policy=DIRECT, tag=AppStore.lsr, enabled=true
https://rule.kelee.one/Loon/DouYin.lsr, policy=DIRECT, tag=DouYin.lsr, enabled=true
https://rule.kelee.one/Loon/AppleID.lsr, policy=DIRECT, tag=AppleID.lsr, enabled=true
https://kelee.one/Tool/Loon/Lsr/SpeedtestInternational.lsr, policy=OutSide, tag=SpeedtestInternational.lsr, enabled=true
https://kelee.one/Tool/Loon/Lsr/SpeedtestChina.lsr, policy=DIRECT, tag=SpeedtestChina.lsr, enabled=true
https://rule.kelee.one/Loon/Epic.lsr, policy=DIRECT, tag=Epic.lsr, enabled=true
https://rule.kelee.one/Loon/ChinaMedia.lsr, policy=DIRECT, tag=ChinaMedia.lsr, enabled=true
https://rule.kelee.one/Loon/ChinaIPsBGP.lsr, policy=DIRECT, tag=ChinaIPsBGP.lsr, enabled=true
https://rule.kelee.one/Loon/ChinaIPs.lsr, policy=DIRECT, tag=ChinaIPs.lsr, enabled=true
https://rule.kelee.one/Loon/ChinaDNS.lsr, policy=DIRECT, tag=ChinaDNS.lsr, enabled=true
https://rule.kelee.one/Loon/ChinaASN.lsr, policy=DIRECT, tag=ChinaASN.lsr, enabled=true
https://rule.kelee.one/Loon/China.lsr, policy=DIRECT, tag=China.lsr, enabled=true
https://rule.kelee.one/Loon/CSDN.lsr, policy=DIRECT, tag=CSDN.lsr, enabled=true
https://rule.kelee.one/Loon/BiliBiliIntl.lsr, policy=DIRECT, tag=BiliBiliIntl.lsr, enabled=true
https://rule.kelee.one/Loon/BiliBili.lsr, policy=DIRECT, tag=BiliBili.lsr, enabled=true
https://rule.kelee.one/Loon/Baidu.lsr, policy=DIRECT, tag=Baidu.lsr, enabled=true
https://rule.kelee.one/Loon/BaiDuTieBa.lsr, policy=DIRECT, tag=BaiDuTieBa.lsr, enabled=true
https://rule.kelee.one/Loon/AliPay.lsr, policy=DIRECT, tag=AliPay.lsr, enabled=true
https://rule.kelee.one/Loon/115.lsr, policy=DIRECT, tag=115.lsr, enabled=true
https://rule.kelee.one/Loon/12306.lsr, policy=DIRECT, tag=12306.lsr, enabled=true
[Proxy Chain]
[Rule]
# Local Rule
# Type:DOMAIN-SUFFIX,DOMAIN,DOMAIN-KEYWORD,USER-AGENT,URL-REGEX,IP-CIDR,IP-CIDR6,IP-ASN
# Strategy:DIRECT,Proxy,REJECT
# Options:no-resolve(no-resolve(only for cidr))
# IP-CIDR, 192.168.0.0/16, DIRECT
# IP-CIDR, 10.0.0.0/8, DIRECT
# IP-CIDR, 172.16.0.0/12, DIRECT
# IP-CIDR, 127.0.0.0/8, DIRECT
# 配置文件已自带远程GEOIP, cn, DIRECT规则，请勿在此添加
# 请勿修改远程CN REGION规则的排序甚至删除
DOMAIN-SUFFIX,local,DIRECT
GEOIP,CN,DIRECT
FINAL,FINAL


[Host]

[Rewrite]

[Script]

[Plugin]
https://kelee.one/Tool/Loon/Lpx/QuarkBrowser_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/HUPU_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/ColorfulClouds_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/BooHee_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/Beike_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/AppleWeatherEnhancer.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/MangoTV_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/YouTube_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/XunLei_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/XiaoHeiHe_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/WPS_Documents_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/WexinMiniPrograms_Remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/Weixin_Official_Accounts_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/Weixin_external_links_unlock.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/Weibo_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/Umetrip_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/TXDocs_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/Tieba_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/Taobao_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/SF-Express_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/RedPaper_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/Remove_ads_by_keli.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/QQ_Redirect.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/PuPuMall_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/Prevent_DNS_Leaks.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/PinDuoDuo_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/Node_detection_tool.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/NodeLinkCheck.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/NeteaseCloudMusic_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/LuckinCoffee_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/LoonGallery.lpx, policy=全球手动, enabled=true
https://kelee.one/Tool/Loon/Lpx/JD_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/FleaMarket_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/DragonRead_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/DouBan_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/DiDi_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/Cainiao_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/Bilibili_remove_ads.lpx, enabled=false
https://kelee.one/Tool/Loon/Lpx/BaiduSearchWebpage_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/BaiduPhoto_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/BaiduNetDisk_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/Amap_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/12306_remove_ads.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/1.1.1.1.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/BlockAdvertisers.lpx, enabled=true
https://kelee.one/Tool/Loon/Lpx/Block_HTTPDNS.lpx, enabled=true
https://raw.githubusercontent.com/lige47/QuanX-icon-rule/main/scripts/wangluoxinxi.plugin, enabled=true
https://raw.githubusercontent.com/fmz200/wool_scripts/main/Loon/plugin/weibo.plugin, enabled=true
https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/script/startup/startup.lnplugin, enabled=true
https://raw.githubusercontent.com/fmz200/wool_scripts/main/Loon/plugin/blockAds.plugin, enabled=true

[Mitm]
ca-p12 = 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
ca-passphrase = 3FX315BQ
hostname =
ca-p12 = 
ca-passphrase = 
skip-server-cert-verify = false
```

