[可视化GIT管理](https://www.sourcetreeapp.com/)  这个工具MAC端比较好用 win使用起来很一般

# 快速GITPUSH

你希望的快捷名字.bat

```
@echo off
powershell -ExecutionPolicy Bypass -NoLogo -NoProfile -Command ^
    "& {Set-Location '%CD%'; . '%~dp0git-auto-push.ps1'}"

```

git-auto-push.ps1

```
# 询问用户输入提交信息
Write-Host "`n✅ 开始执行 git pull 拉取仓库内容" -ForegroundColor Green

git pull 

$commitMessage = Read-Host "请输入本次提交的评论"

# 确认当前目录是否是 Git 仓库
if (-not (Test-Path ".git")) {
    Write-Host "❌ 当前目录不是一个 Git 仓库！" -ForegroundColor Red
    exit 1
}

# 添加所有更改
git add .

# 提交
git commit -m "$commitMessage"

# 推送到远程
git push -u  origin main 

Write-Host "`n✅ 已自动提交并推送到远程仓库！（评论: $commitMessage）" -ForegroundColor Green

```

![image-20250901212328745](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250901212328745.png)

我这里设置的是gip命令

存入环境变量

![image-20250901212403179](https://raw.githubusercontent.com/Xioaruan912/pic/main/image-20250901212403179.png)
