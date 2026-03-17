# Windos

```
 https://rclone.org/downloads/
```

解压到任意文件夹，比如 C:\rclone\

```
rclone version
```

# 帮助Linux认证

```
rclone authorize onedrive
```

会打开浏览器 然后认证

```
{"access_token":"xxxx","expiry":"123123130","expires_in":12313}
```

# Linux

```
curl https://rclone.org/install.sh | sudo bash
mkdir rclone
vim rclone/rclone.conf
```

```
[myonedrive]
type = onedrive
token = <你刚才复制的JSON字符串，注意整个字符串一行写入>

```

```
root@C202506171698481:~/rclone# rclone config
Current remotes:

Name                 Type
====                 ====
myonedrive           onedrive

e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q> e

Select remote.
Choose a number from below, or type in an existing value.
 1 > myonedrive
remote> 1

Editing existing "myonedrive" remote with options:
- type: onedrive
- token: {"access_token":"}

Option client_id.
OAuth Client Id.
Leave blank normally.
Enter a value. Press Enter to leave empty.
client_id> 

Option client_secret.
OAuth Client Secret.
Leave blank normally.
Enter a value. Press Enter to leave empty.
client_secret> 

Option region.
Choose national cloud region for OneDrive.
Choose a number from below, or type in your own value of type string.
Press Enter for the default (global).
 1 / Microsoft Cloud Global
   \ (global)
 2 / Microsoft Cloud for US Government
   \ (us)
 3 / Microsoft Cloud Germany (deprecated - try global region first).
   \ (de)
 4 / Azure and Office 365 operated by Vnet Group in China
   \ (cn)
region> 

Option tenant.
ID of the service principal's tenant. Also called its directory ID.
Set this if using
- Client Credential flow
Enter a value. Press Enter to leave empty.
tenant> 

Edit advanced config?
y) Yes
n) No (default)
y/n> 

Already have a token - refresh?
y) Yes (default)
n) No
y/n> n

Option config_type.
Type of connection
Choose a number from below, or type in an existing value of type string.
Press Enter for the default (onedrive).
 1 / OneDrive Personal or Business
   \ (onedrive)
 2 / Root Sharepoint site
   \ (sharepoint)
   / Sharepoint site name or URL
 3 | E.g. mysite or https://contoso.sharepoint.com/sites/mysite
   \ (url)
 4 / Search for a Sharepoint site
   \ (search)
 5 / Type in driveID (advanced)
   \ (driveid)
 6 / Type in SiteID (advanced)
   \ (siteid)
   / Sharepoint server-relative path (advanced)
 7 | E.g. /teams/hr
   \ (path)
config_type> 

Option config_driveid.
Select drive you want to use
Choose a number from below, or type in your own value of type string.
Press Enter for the default ().
 1 / OneDrive (personal)
   \ 
 2 / AEEE1(personal)
   \ 
 3 / ODCMetadataArchive (personal)
   \ 
config_driveid> 

Drive OK?

Found drive "root" of type "personal"
URL: https://onedrive.live.com?cid=Z

y) Yes (default)
n) No
y/n> 

Configuration complete.
Options:
- type: onedrive
- token: {"access_token":"你的token}
- drive_id: 31CE77D2E5061C53
- drive_type: personal
Keep this "myonedrive" remote?
y) Yes this is OK (default)
e) Edit this remote
d) Delete this remote
y/e/d> 

Current remotes:

Name                 Type
====                 ====
myonedrive           onedrive

e) Edit existing remote
n) New remote
d) Delete remote
r) Rename remote
c) Copy remote
s) Set configuration password
q) Quit config
e/n/d/r/c/s/q> q
```

测试链接是否成功

```
rclone lsd myonedrive:
```

```
~/rclone# rclone lsd myonedrive:
          -1 2024-08-01 14:25:26         1 Documents
          -1 2024-08-01 14:29:23         0 OneNote 上传
          -1 2020-05-02 11:32:37         1 图片
          -1 2020-05-02 11:32:37         9 文档
          -1 2024-04-23 15:56:41         0 附件
```

